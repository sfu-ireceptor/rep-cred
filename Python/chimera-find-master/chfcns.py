import sys
import os
import glob

""" this is all copied from partis/python/{utils.py,plotting.py} """

ambiguous_bases = ['N', ]
gap_chars = ['.', '-']

# ----------------------------------------------------------------------------------------
def ambig_frac(seq):
    ambig_seq = filter(ambiguous_bases.__contains__, seq)
    return float(len(ambig_seq)) / len(seq)

# ----------------------------------------------------------------------------------------
def hamming_distance(seq1, seq2, return_mutated_positions=False):
    if len(seq1) != len(seq2):
        raise Exception('unequal length sequences %d %d:\n  %s\n  %s' % (len(seq1), len(seq2), seq1, seq2))
    if len(seq1) == 0:
        if return_len_excluding_ambig:
            return 0, 0
        else:
            return 0

    skip_chars = set(ambiguous_bases + gap_chars)

    distance, len_excluding_ambig = 0, 0
    mutated_positions = []
    for ich in range(len(seq1)):  # already made sure they're the same length
        if seq1[ich] in skip_chars or seq2[ich] in skip_chars:
            continue
        len_excluding_ambig += 1
        if seq1[ich] != seq2[ich]:
            distance += 1
            if return_mutated_positions:
                mutated_positions.append(ich)

    if return_mutated_positions:
        return distance, mutated_positions
    else:
        return distance

# ----------------------------------------------------------------------------------------
def get_chimera_max_abs_diff(naive_v_seq, mature_v_seq, chunk_len=75, max_ambig_frac=0.1, debug=False):
    if ambig_frac(naive_v_seq) > max_ambig_frac or ambig_frac(mature_v_seq) > max_ambig_frac:
        if debug:
            print '  too much ambig %.2f %.2f' % (ambig_frac(naive_v_seq), ambig_frac(mature_v_seq))
        return None, 0.

    # if debug:
    #     color_mutants(naive_v_seq, mature_v_seq, print_result=True)
    #     print ' '.join(['%3d' % s for s in isnps])

    _, isnps = hamming_distance(naive_v_seq, mature_v_seq, return_mutated_positions=True)

    max_abs_diff, imax = 0., None
    for ipos in range(chunk_len, len(mature_v_seq) - chunk_len):
        if debug:
            print ipos

        muts_before = [isn for isn in isnps if isn >= ipos - chunk_len and isn < ipos]
        muts_after = [isn for isn in isnps if isn >= ipos and isn < ipos + chunk_len]
        mfreq_before = len(muts_before) / float(chunk_len)
        mfreq_after = len(muts_after) / float(chunk_len)

        if debug:
            print '    len(%s) / %d = %.3f' % (muts_before, chunk_len, mfreq_before)
            print '    len(%s) / %d = %.3f' % (muts_after, chunk_len, mfreq_after)

        abs_diff = abs(mfreq_before - mfreq_after)
        if imax is None or abs_diff > max_abs_diff:
            max_abs_diff = abs_diff
            imax = ipos

    return {'imax' : imax, 'max_abs_diff': max_abs_diff}  # <imax> is break point

# ----------------------------------------------------------------------------------------
def mpl_init(figsize=None, fontsize=20):
    import matplotlib
    from matplotlib import pyplot as plt
    import seaborn
    seaborn.set_style('ticks')
    seaborn.despine()

    fsize = fontsize
    matplotlib.rcParams.update({
        # 'legend.fontweight': 900,
        'legend.fontsize': fsize,
        'axes.titlesize': fsize,
        # 'axes.labelsize': fsize,
        'xtick.labelsize': fsize,
        'ytick.labelsize': fsize,
        'axes.labelsize': fsize
    })

    fig, ax = plt.subplots()
    fig.tight_layout()
    plt.gcf().subplots_adjust(bottom=0.16, left=0.2, right=0.78, top=0.92)

    return fig, ax

# ----------------------------------------------------------------------------------------
def mpl_finish(ax, plotdir, plotname, title='', xlabel='', ylabel='', xbounds=None, ybounds=None, leg_loc=(0.04, 0.6), leg_prop=None, log='',
               xticks=None, xticklabels=None, xticklabelsize=None, yticks=None, yticklabels=None, no_legend=False, adjust=None, suffix='svg', leg_title=None):
    import matplotlib
    from matplotlib import pyplot as plt
    import seaborn

    if not no_legend:
        handles, labels = ax.get_legend_handles_labels()
        if len(handles) > 0:
            legend = ax.legend(handles, labels, loc=leg_loc, prop=leg_prop, title=leg_title)
    if adjust is None:
        plt.gcf().subplots_adjust(bottom=0.20, left=0.18, right=0.95, top=0.92)
    else:
        plt.gcf().subplots_adjust(**adjust)
    sys.modules['seaborn'].despine()  #trim=True, bottom=True)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    if 'x' in log:
        ax.set_xscale('symlog')  # 'log' used to work, but now it screws up the x axis labels
    if 'y' in log:
        ax.set_yscale('log')
    if xbounds is not None and xbounds[0] != xbounds[1]:
        plt.xlim(xbounds[0], xbounds[1])
    if ybounds is not None and ybounds[0] != ybounds[1]:
        plt.ylim(ybounds[0], ybounds[1])
    if xticks is not None:
        plt.xticks(xticks)
    if yticks is not None:
        plt.yticks(yticks)
    if xticklabels is not None:
        # mean_length = float(sum([len(xl) for xl in xticklabels])) / len(xticklabels)
        median_length = numpy.median([len(xl) for xl in xticklabels])
        if median_length > 4:
            ax.set_xticklabels(xticklabels, rotation='vertical', size=8 if xticklabelsize is None else xticklabelsize)
        else:
            ax.set_xticklabels(xticklabels)
    if yticklabels is not None:
        ax.set_yticklabels(yticklabels)
    plt.title(title, fontweight='bold')
    if not os.path.exists(plotdir):
        os.makedirs(plotdir)

    fullname = plotdir + '/' + plotname + '.' + suffix
    plt.savefig(fullname)
    plt.close()
    # subprocess.check_call(['chmod', '664', fullname])

# ----------------------------------------------------------------------------------------
def make_html(plotdir, n_columns=3, extension='svg', fnames=None, title='foop', new_table_each_row=False, htmlfname=None, extra_links=None):
    if plotdir[-1] == '/':  # remove trailings slash, if present
        plotdir = plotdir[:-1]
    if not os.path.exists(plotdir):
        raise Exception('plotdir %s d.n.e.' % plotdir)
    dirname = os.path.basename(plotdir)
    extra_link_str = ''
    if extra_links is not None:
        extra_link_str = ' '.join(['<a href=%s>%s</a>' % (url, name) for name, url in extra_links])
    lines = ['<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN>',
             '<html>',
             '<head><title>' + title + '</title></head>',
             '<body bgcolor="000000">', 
             '<h3 style="text-align:left; color:DD6600;">' + title + '</h3>',
             extra_link_str,
             '<table>',
             '<tr>']

    def add_newline(lines):
        if new_table_each_row:
            newlines = ['</tr>', '</table>', '<table>', '<tr>']
        else:
            newlines = ['</tr>', '<tr>']
        lines += newlines
    def add_fname(lines, fullfname):  # NOTE <fullname> may, or may not, be a base name (i.e. it might have a subdir tacked on the left side)
        fname = fullfname.replace(plotdir, '').lstrip('/')
        if htmlfname is None:  # dirname screws it up if we're specifying htmfname explicitly, since then the files are in a variety of different subdirs
            fname = dirname + '/' + fname
        line = '<td><a target="_blank" href="' + fname + '"><img src="' + fname + '" alt="' + fname + '" width="100%"></a></td>'
        lines.append(line)

    # if <fnames> wasn't used to tell us how to group them into rows, try to guess based on the file base names
    if fnames is None:
        fnamelist = [os.path.basename(fn) for fn in sorted(glob.glob(plotdir + '/*.' + extension))]
        fnames = []

        # then do the rest in groups of <n_columns>
        while len(fnamelist) > 0:
            fnames.append(fnamelist[:n_columns])
            fnamelist = fnamelist[n_columns:]

    # write the meat of the html
    for rowlist in fnames:
        for fn in rowlist:
            add_fname(lines, fn)
        add_newline(lines)

    lines += ['</tr>',
              '</table>',
              '</body>',
              '</html>']

    if htmlfname is None:
        htmlfname = os.path.dirname(plotdir) + '/' + dirname + '.html'  # more verbose than necessary
    with open(htmlfname, 'w') as htmlfile:
        htmlfile.write('\n'.join(lines))
    # subprocess.check_call(['chmod', '664', htmlfname])

#!/usr/bin/env python
import csv
import collections
import argparse
import sys
import os
import colored_traceback.always

import chfcns
from hist import Hist

class MultiplyInheritedFormatter(argparse.RawTextHelpFormatter, argparse.ArgumentDefaultsHelpFormatter):
    pass
formatter_class = MultiplyInheritedFormatter
parser = argparse.ArgumentParser(formatter_class=MultiplyInheritedFormatter)
parser.add_argument('infile', help='input csv file with naive/mature V region sequence pairs (see examples/)')
parser.add_argument('--chunk-len', default=75, help='length over which to calculate maximum absolute difference (see explanation slides)')
parser.add_argument('--cutoff', default=0.3, help='max-abs-diff value above which we assume most sequences are chimeric')
parser.add_argument('--plotdir', help='if set, write plots to this dir')
args = parser.parse_args()

# ----------------------------------------------------------------------------------------
colors = {'no-chimeras' : 'green', 'all-chimeras' : 'darkred', 'data' : 'grey'}

# ----------------------------------------------------------------------------------------
def read_file(fname, debug=False):
    with open(fname) as yfile:
        seqfos = []
        reader = csv.DictReader(yfile)
        for line in reader:
            seqfos.append(line)
    chinfo = {}
    for sfo in seqfos:
        chinfo[sfo['uid']] = chfcns.get_chimera_max_abs_diff(sfo['v_naive'], sfo['v_mature'], chunk_len=args.chunk_len)

    n_above_cutoff = len([cfo for cfo in chinfo.values() if cfo['max_abs_diff'] > args.cutoff])
    chimeric_fraction = n_above_cutoff / float(len(chinfo))
    if debug:
        print '  %d / %d = %.3f above chimeric cutoff of %.2f' % (n_above_cutoff, len(chinfo), chimeric_fraction, args.cutoff)

    return chinfo

# ----------------------------------------------------------------------------------------
chfos = collections.OrderedDict()
chfos['no-chimeras'] = read_file(os.path.dirname(os.path.realpath(__file__)) + '/examples/no-chimeras.csv')
chfos['all-chimeras'] = read_file(os.path.dirname(os.path.realpath(__file__)) + '/examples/all-chimeras.csv')
chfos['data'] = read_file(args.infile, debug=True)

if args.plotdir is not None:
    print 'writing to %s' % args.plotdir
    import matplotlib
    from matplotlib import pyplot as plt

    if not os.path.exists(args.plotdir):
        os.makedirs(args.plotdir)

    fig, ax = chfcns.mpl_init()
    xvals, yvals = zip(*[(v['imax'], v['max_abs_diff']) for v in chfos['data'].values()])
    plt.scatter(xvals, yvals, alpha=0.4)
    chfcns.mpl_finish(ax, args.plotdir, 'imax-vs-max-abs-diff', xlabel='break point', ylabel='abs mfreq diff')
    plt.close()

    fig, ax = chfcns.mpl_init()
    xmin, xmax = 0., 0.65
    for sample, chfo in chfos.items():
        hmaxval = Hist(45, xmin, xmax, value_list=[chfo[u]['max_abs_diff'] for u in chfo])
        hmaxval.normalize()
        hmaxval.mpl_plot(ax, color=colors[sample], label=sample)
    chfcns.mpl_finish(ax, args.plotdir, 'mfreq-diff', xlabel='abs mfreq diff', ylabel='freq', xbounds=(xmin - 0.02, xmax), leg_loc=(0.5, 0.6))

    fig, ax = chfcns.mpl_init()
    xmin, xmax = 0., 300
    for sample, chfo in chfos.items():
        himax = Hist(75, xmin, xmax, value_list=[chfo[u]['imax'] for u in chfo])
        himax.normalize()
        himax.mpl_plot(ax, color=colors[sample], label=sample)
    chfcns.mpl_finish(ax, args.plotdir, 'imax', xlabel='break point', ylabel='freq', xbounds=(xmin, xmax), leg_loc=(0.5, 0.6))

    chfcns.make_html(args.plotdir)

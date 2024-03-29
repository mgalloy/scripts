#!/usr/bin/env python

import argparse
import glob
import itertools
import os
import re


DELIMS = '-._'
SEP = re.compile(f'([{DELIMS}])')
EXT_SEP = re.compile(f'([.])')

'''
For a directory with the following listing:

comp-2017.out
find_noncordyn_files.sh
fix_noncordyn_files.sh
hpss
hpss-chip.log
hpss-CHIP.log
hpss-comp.log
hpss-CORDYN.log
hpss-FS-UC.log
hpss_gateway.sh
hpss-get-output
hpss_get.sh
hpss-kcor.log
hpss-SMM-cal.log
hpss-SMM-DOY.log
hpss-SMM-exb.log
hpss-SMM-IPD.log
hpss-SMM.log
hpss-SMM-raw.log
hpss-SMM-STANGER.log
kcor_current_month_report.sh
kcor_makelog.sh
kcor_report
Makefile
cls
smm-report.txt
watch_hpss

`cls` should output:

hpss
Makefile
cls
watch_hpss
kcor_report
hpss-*.log: 6 files
smm-report.txt
hpss_get.sh
comp-2017.out
hpss-get-output
hpss_gateway.sh
kcor_makelog.sh
{find,fix}_noncordyn_files.sh
hpss-SMM-*.log: 6 files
hpss-FS-UC.log
kcor_current_month_report.sh
'''

class Location:
    value = -1

    def __init__(self, v):
        self.value = v

    def __repr__(self):
        return(f"Location({self.value})")


def collective_name(filenames):
    isdirs = [os.path.isdir(f) for f in filenames]
    isfiles = [os.path.isfile(f) for f in filenames]
    islinks = [os.path.islink(f) for f in filenames]
    if all(isdirs): return("directories", "/")
    if all(isfiles): return("files", "")
    if all(islinks): return("links", "@")
    return("items", "")


def print_subgroup(subgroup, diff_loc, output, max_listed=3):
    cname, csymbol = collective_name([sg[0] for sg in subgroup])
    n = len(subgroup)
    if n == 1:
        output.append(subgroup[0][0] + csymbol)
    elif n <= max_listed:
        parts = [s[1][diff_loc] for s in subgroup]
        sorted_parts = sorted(parts, key=str.lower)
        s = subgroup[0][1]
        pattern = "".join(s[:diff_loc]
                          + ["{" + ",".join(sorted_parts) + "}"]
                          + s[diff_loc + 1:])
        output.append(pattern + csymbol)
    else:
        s = subgroup[0][1]
        pattern = "".join(s[:diff_loc] + ["*"] + s[diff_loc + 1:])
        output.append(f"{pattern}{csymbol} [{n} {cname}]")


def match_except_one(g1, g2):
    n_nonmatches = 0
    diff_loc = -1
    for i, (gl1, gl2) in enumerate(zip(g1[1], g2[1])):
        if gl1 != gl2:
            n_nonmatches += 1
            diff_loc = i

    return (True, diff_loc) if n_nonmatches == 1 else (False, -1)


def find_subgroups_naive(group):
    '''Return list of tuples (subgroup, diff_loc).'''
    subgroups = []

    for g in group:
        if len(subgroups) == 0:
            subgroups.append(([g], Location(-1)))
        else:
            for s in subgroups:
                match, diff_loc = match_except_one(g, s[0][0])
                if match:
                    if s[1].value == -1:
                        s[0].append(g)
                        s[1].value = diff_loc
                        break
                    elif s[1].value == diff_loc:
                        s[0].append(g)
                        break
            else:
                subgroups.append(([g], Location(-1)))

    return subgroups


def list_grouped_files(group, output, **kwargs):
    '''List files in groups.'''
    for s, d in find_subgroups_naive(group):
        print_subgroup(s, d.value, output, **kwargs)


def list_files(filenames, **kwargs):
    output = []
    dots = [SEP.split(f) for f in filenames]
    #sorted_filenames = sorted(zip(filenames, dots), key=lambda x: len(x[1]))
    sorted_filenames = zip(filenames, dots)
    for e, group in itertools.groupby(sorted_filenames, lambda x: len(x[1])):
        group = list(group)
        filenames = [g[0] for g in group]
        parts = [g[1] for g in group]
        n = len(filenames)
        n_parts = len(parts[0])
        if n_parts == 1:
            for f in filenames:
                cname, csymbol = collective_name([f])
                output.append(f + csymbol)
        elif n == 1:
            cname, csymbol = collective_name(filenames)
            output.append(filenames[0] + csymbol)
        else:
            list_grouped_files(group, output, **kwargs)

    def file_sorting_key(line):
        parts = line.split()
        fname = parts[0]
        parts = EXT_SEP.split(fname)
        ext = parts[-1] if len(parts) > 1 else ''
        clean_line = line.replace('*', '~')
        clean_line = clean_line.replace('{', '').replace('}', '')
        #return f"{ext.lower()}|{clean_line.lower()}"
        return f"{ext}|{clean_line}"

    sorted_output = sorted(output, key=file_sorting_key)
    for o in sorted_output:
        print(o)


def list_dir(dirname, multiple=False, **kwargs):
    items = glob.glob(os.path.join(dirname, '*'))

    filenames = [os.path.basename(f) for f in items if os.path.isfile(f)]
    dirnames = [os.path.basename(d) for d in items if os.path.isdir(d)]

    filenames = sorted(filenames)
    dirnames = sorted(dirnames)

    if multiple: print(f"{dirname}/:")
    list_files(dirnames, **kwargs)
    list_files(filenames, **kwargs)


def list_spec(files, **kwargs):
    filenames = [f for f in files if os.path.isfile(f)]
    dirnames = [d for d in files if os.path.isdir(d)]

    filenames = sorted(filenames)
    dirnames = sorted(dirnames)

    for i, d in enumerate(dirnames):
        if i > 0: print()
        list_dir(d, multiple=len(files) > 1, **kwargs)

    if len(filenames) > 0 and len(dirnames) > 0:
        print()

    list_files(filenames, **kwargs)


# features to add:
#   - accept -l ls argument
#   - add emoji icons for classes of items
#   - tree functionality
#   - accept -a ls argument
#   - include size in bytes along with number of files
if __name__ == "__main__":
    version = "0.0.2"
    name = f"Clustered ls {version}"
    parser = argparse.ArgumentParser(description=name)
    parser.add_argument("files", type=str, nargs="*",
                        help="path specification to check", default=".")
    parser.add_argument("-m", "--max-listed", type=int, default=3,
                        help="max number of files to explicitly list")
    args = parser.parse_args()

    list_spec(args.files, max_listed=args.max_listed)

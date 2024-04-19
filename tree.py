#!/usr/bin/env python

"""
Demonstrates how to display a tree of files / directories with the Tree renderable.
"""

import os
import collections
import pathlib
import sys

from rich import print
from rich.filesize import decimal
from rich.markup import escape
from rich.text import Text
from rich.tree import Tree


def walk_directory(directory: pathlib.Path, tree: Tree, only_dirs=False, show_hidden=False) -> None:
    """Recursively build a Tree with directory contents."""
    # Sort dirs first then by filename
    paths = sorted(
        pathlib.Path(directory).iterdir(),
        key=lambda path: (path.is_file(), path.name.lower()),
    )
    icons = collections.defaultdict(lambda: "📄")
    icons[".py"] = "🐍"
    icons[".pro"] = "📈"
    icons[".pl"] = "🐪"
    icons[".sh"] = "📜"
    icons[".in"] = "✉️ "
    icons[".txt"] = "📋"
    icons[".cfg"] = "⚙️ "
    icons[".gz"] = "🗜 "
    icons[".log"] = "📔"
    icons[".gif"] = "🖼 "
    icons[".png"] = "🖼 "
    icons[".jpg"] = "🖼 "
    icons[".mp4"] = "🎥"
    icons[".html"] = "🌎"

    for path in paths:
        # Remove hidden files
        if path.name.startswith(".") and show_hidden == False:
            continue
        if path.is_dir():
            style = "dim" if path.name.startswith("__") else ""
            branch = tree.add(
                f"[bold magenta]:open_file_folder: [link file://{path}]{escape(path.name)}",
                style=style,
                guide_style=style,
            )
            walk_directory(path, branch, only_dirs)
        elif only_dirs == False:
            style = "dim" if path.name.startswith(".") else ""
            text_filename = Text(path.name, "green")
            text_filename.highlight_regex(r"\..*$", "bold red")
            text_filename.stylize(f"link file://{path}")
            file_size = path.stat().st_size
            text_filename.append(f" ({decimal(file_size)})", "blue")

            icon = icons[path.suffix]
            tree.add(Text(icon) + " " + text_filename, style=style)


try:
    directory = os.path.abspath(sys.argv[1])
except IndexError:
    print("[b]Usage:[/] python tree.py <DIRECTORY>")
else:
    tree = Tree(
        f":open_file_folder: [link file://{directory}]{directory}",
        guide_style="bold bright_blue",
    )
    walk_directory(pathlib.Path(directory), tree, False, True)
    print(tree)

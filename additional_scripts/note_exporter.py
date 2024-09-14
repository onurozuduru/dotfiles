#!/usr/bin/env python3
###############################################################################
#File: extract_pytorch_notebooks.sh
#
#License: MIT
#
#Copyright (C) 2024 Onur Ozuduru
#
#Follow Me!
#  github: github.com/onurozuduru
###############################################################################

from os import mkdir
from lxml.html import parse
import argparse


def remove_from_body(body):
    remove_classes = ["notebookFor", "bookTitle", "authors", "citation"]
    remove_tags = ["hr"]
    for remove_class in remove_classes:
        found = body.find_class(remove_class)
        if len(found) > 0:
            body.remove(found[0])
    for remove_tag in remove_tags:
        found = body.xpath(remove_tag)
        if len(found) > 0:
            body.remove(found[0])
    return body


def generate_file_name(output_dir, el):
    name = el.text_content()
    name = name.strip("\n").replace(" ", "_")
    name = name.replace(",","").replace(".","").replace("'","")
    name = name.replace(":", "").replace("’", "")
    return output_dir + "/" + name + ".md"


def format_text(el):
    text = el.text_content().strip("\n")
    if text.isupper():
        text = "# " + text.title()
        if not text.startswith("# Law"):
            text = "#" + text
    return text + "\n"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('filename')
    parser.add_argument('outdir')
    args = parser.parse_args()
    filename = args.filename
    outdir = args.outdir

    print(f"Filename: {filename}\nOutdir: {outdir}\n")
    print("Parsing...")

    html_content = parse(filename)
    root = html_content.getroot()
    noteheadings = root.find_class("noteHeading")
    for noteheading in noteheadings:
        noteheading.getparent().remove(noteheading)

    body = root.find_class("bodyContainer")[0]
    body = remove_from_body(body)
    children = body.getchildren()
    print("Found elements: " + str(len(children)))

    mkdir(outdir)
    output_file_path = ""

    for child in children:
        if child.attrib["class"] == "sectionHeading":
            output_file_path = generate_file_name(outdir, child)
            print(f"Generating file: {output_file_path}")
            continue
        if output_file_path != "":
            with open(output_file_path, "a") as output_file:
                output_file.write(format_text(child))
    print("DONE")






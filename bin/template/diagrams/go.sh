#!/bin/bash
echo Full Documentation: https://www.graphviz.org/documentation/
echo Command Line Reference: https://www.graphviz.org/doc/info/command.html
echo Graphviz Language Reference: https://www.graphviz.org/doc/info/lang.html
echo Graph, Node, Edge Attributes: https://www.graphviz.org/doc/info/attrs.html
echo Node Shapes: https://www.graphviz.org/doc/info/shapes.html
echo Colors: https://www.graphviz.org/doc/info/col-ors.html
echo " "
echo Online diagramming with graphviz language support:
echo https://draw.io/
echo https://www.diagrams.net/
echo https://edotor.net/
echo http:magjac.com/graphviz-visual-editor/
echo " "
dot -T: 2>&1 | perl -pne 's{Format.+Use.one.of:\s*}{Graphviz-Output-Formats-Supported: }xms; s{\s+}{\n}xmsg; s{-}{ }xmsg'
dot -P -Tsvg > graphviz-output-format-plugins.svg
echo " "
ls *.svg

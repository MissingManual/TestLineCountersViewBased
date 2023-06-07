# TestLineCountersViewBased
Check different line counts

This Xcode project uses different algorithms to determine the linecount of the cursor position. The line count and the horizontal position as well as the required timings are tabulated and displayed as graph.

The surprising result is that using the regular expression is by far the fastest solution. This is true for M2 and Intel (roughly similar results). The algorithms that use LineRange, Components or Enumeration are quite comparable in performance, while reduce is very slow. What surprises me, admittedly, is that the scanner solution is also very slow.  

Tested with Xcode 14 under Ventura (ResultPreview.jpg)

## Requirements
The project make use of Charts.xcodeproj to be downloaded from 
https://github.com/danielgindi/Charts

Please move the Charts.xcodeproj directly under the Frameworks item in the navigation pane as shown in the picture (Embedd Charts.jpg).

## Side remark
Benchmarking could have been done using Xcode Instruments, but this was an opportunity to learn how to use the charts framework,
that in fact is very nicely written.



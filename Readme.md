SSGraph / SSGraphDemo
=====================

SSGraph is a graphing (charting) library for iOS with a focus on  time based data, such as financial data. It uses Core Graphics to do all of it's drawing. It currently supports line and bar styles.

Other features include:

* Auto-calculates axes, including major and minor gridlines
* Live panning of the graph, with axis readjustment on the fly
* Pinch-to-zoom, with accompanying increases in data resolution and smart, x-axis reformatting (years become quarters, quarters become weeks)
* Data resolution requests on-demand, for supporting large data sets (currently uses Yahoo stock history in CSV)
* Customizable styles, so you can specify filled graphs and 
* Multiple data sets per graph (for comparing stocks)
* Percent change and value change modes
* Logarithmic Y-axis
* Single point selection, for seeing the value of a specific point
* Annotations, for adding contextual data such as stock splits
* Synchronize multiple graphs to one x-axis (such as a stock price and volume graphs)

# A word of warning
Although originally written in 2010, converted to ARC in 2012, and published in 2014, SSGraph is still very much in a "pre-alpha" state, and I don't expect to spend much time maintaining it. If you use it, please be prepared that you will need to make changes to it. It has not been made into a cocoapod.

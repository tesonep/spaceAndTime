# Pharo Space and Time
An small project to add some statistics generating code for used space and time for Pharo.

Right now it includes only a simple tool to analyze space usage by a graph of objects.
But more to come.

## Installation

```
Metacello new
    baseline: 'SpaceAndTime';
    repository: 'github://tesonep/spaceAndTime/';
    load.
```

## GraphSpaceStatistics

This is the class that can be used to inspect the statistics of space usage of a given graph of objects.
It uses a GraphWalker to get all the recheable objects in the graph. 
This object understands messages to access the statistics. 

It gives: 

- totalInstances: The total number of instances
- totalSizeInBytes: The sum of all the space used by the objects in the graph
- statisticsPerClass: a collection of GraphSpaceStatisticsPerClass with the information for each of the classes the graph have instances.
- statisticsPerClassCSV: a simple CSV to import in your favorite analysis and graphing tool.

### Usage

```
stats := GraphSpaceStatistics new
	rootObject: rootOfTheGraph;
	yourself.

stats totalSizeInBytes.
stats totalInstances.
stats statisticsPerClass.	
stats statisticsPerClassCSV.
```

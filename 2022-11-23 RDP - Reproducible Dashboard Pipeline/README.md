# RDP: Reproducible Dashboard Pipeline

## What is RDP?

RDP stands for Reproducible Dashboard Pipeline. It is an analogue to RAPs, Reproducible Analytical Pipelines. The main aim of any reproducible pipeline is to enable anyone to easily replicate some set of actions and get the same result from any given starting point. The core of RAP is best practice software development.

The starting point in RAP is one or more sets of data, and the end point is some sort of report or simply statistics created following analysis of the starting data.

Similarly, the starting point in RDP is some data. But the final product is a dashboard or app used as a method of visualising and providing insights on the data. Of course, every dashboard uses different data, but the aim is to make as many of the steps needed to create a dashboard as automatic, standardised and easily maintainable as possible.

## How the Management Information team currently work

By far the most common reason for the MI team to build a dashboard is as a medium allowing stakeholders in a service to visualise the data gathered in customer surveys (CSATs). We use the R package `{shiny}` to build a web app.

Before going on, I hope the rest of the MI team do not take offense with what I am saying here - I am as guilty as anyone!

The process a team member uses is roughly like this:

1. Get the data from Customer Insight team
2. Start with their preferred template for a `{shiny}` app
3. Writing, but also a lot of copy and pasting, code
4. Deploy the app to shinyapps.io

Because each team member uses their own style, and over time they change their style, almost every dashboard is done differently. The difference may be slight for the dashboards create dby one person, but for dashboards created by different people the differences are huge.

With each dashboard having all of its code locally, the DRY (don't repeat yourself) principle is not being used. Any time some global change to the apps is needed, it means going into each apps code and updating. This is time consuming, error prone and code that should be updated can be easily missed.

Together, the above 2 points make maintaining dashboards a big overhead for the team.


## How can RDP help?

Even before the Goldacre report was published and RAP became the buzzword it is now (not to detract, it is a good thing it is a buzzword!), I created a package `{devpacker}` to automate beginning with some best practices. This can be used to create a new package or `{shiny}` app that will automatically:

1. Create the basic package or app files
2. Initialise a git repo.
3. Set up testing with `{testthat}`.
4. Add code linting, using `{lintr}`.
5. Set up checks to be made on every git commit, using `{precommit}.
6. Create a remote repo on GitHub and push the package.
7. Add a README.
8. Set up code coverage with `{covr}`.
9. Add a couple of basic CI workflows, using GitHub Actions.
10. Finally push everything to GitHub.

Also, I have created a (still WIP) package `{projecthooks}` which is specific to creating `{shiny}` apps. A project hook is a function passed into the `{golem}` package, that will run once a project is first created. This means that anyone can write specific project hooks tailored to how they create their `{shiny}` apps. At present it only has one hook, `nhsbsa_mi_project_hook`, which is tailored to how *I* like to do my apps. It is still tightly coupled to some sample data - the next step is to abstract out everything that can be into the package `R` folder. This means adding all the templates and utility functions to the package itself. Despite this, it demonstrates what is possible and proves the concept :)


## Installing the packages

```
devtools::install_github("nhsbsa-data-analytics/devpacker")
devtools::install_github("nhsbsa-data-analytics/projecthooks")
```


## R packages 101

An R package at its simplest is easy to understand. We have:

1. A `DESCRIPTION` file - gives information about the package, with some configuration also.
2. A `NAMESPACE` file - this determines what to import into, and export out of, the package.
3. An `R` folder - all code goes in here

The `{usethis}` package makes creating packages very easy. I would recommend anyone interested in learning how to create packages to read up on it and try it out. 

The `create_package` function in `{devpacker}` is based on `{usethis}`. In fact the first thing it does is wrap the same function from `{usethis}`, before adding all the extras mentioned above.

Here we create a new package using `{devpacker}`:

```
devpacker::create_package("../testpackage")
```

## Shiny apps as a package

The `{golem}` package provides an easy way to create a new `{shiny}` app as an `R` package. Similarly to the `create_package` function, 
`create_shiny` leverages `{golem}`. All arguments are identical between `create_package` and `create_shiny`, but the latter accepts an argument `project_hook`. This function is run after the initial app package is created.

Here we create a new `{shiny}` app using `{devpacker}`:

```
devpacker::create_shiny("../testshiny", project_hook = projecthooks::nhsbsa_mi_project_hook)
```


# catIrt
### An R Package for Simulating IRT-Based Computerized Adaptive Tests

The catIrt package contains functions designed to simulate data that conform to basic unidimensional IRT models along with Post-Hoc CAT simulations of those models given various item selection methods, ability estimation methods, and termination criteria.

Within an R session, type (to install a binary package from CRAN)

```R
install.packages("catIrt")
```

or (to install the most current source package from github)

```R
if(length(find.package("devtools", quiet = TRUE)) == 0)
  install.packages("devtools")
devtools::install_github("swnydick/catIrt")
```

The first two lines of the second code block simply installs the devtools package if R cannot find its location. The devtools package contains the `install_github` function and is needed to easily install packages from github.

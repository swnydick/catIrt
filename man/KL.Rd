\name{KL}
\alias{KL}
\alias{KL.brm}
\alias{KL.grm}
\title{Calculate Kullback-Leibler Divergence for IRT Models}

\description{
\code{KL} calculates the IRT implementation of Kullback-Leibler
divergence for various IRT models given a vector of ability values,
a vector/matrix of item responses, an IRT model, and a value
indicating the half-width of an indifference region.
}

\usage{
KL( params, theta, delta = .1 )
\method{KL}{brm}( params, theta, delta = .1 )
\method{KL}{grm}( params, theta, delta = .1 )
}

\arguments{
  \item{params}{\bold{numeric:} a vector or matrix of item parameters.  If specified
                as a matrix, the rows must index the items, and the columns
                must designate the item parameters.  Furthermore, if calculating
                \emph{expected} information, the number of rows must match the number
                of columns of \command{resp}.  The class of \command{params} must match
                the model: either \option{"brm"} or \option{"grm"}.  For the binary response
                model, \command{params} must either be a 3-dimensional vector or a 3-column
                matrix.  See \bold{Details} for more information.
}
  \item{theta}{\bold{numeric:} a vector of ability values, one for each simulee.  When performing
               a classification CAT, \command{theta} should be the boundary points for which to
               choose the next item.
}
  \item{delta}{\bold{numeric:} a scalar or vector indicating the half-width of the indifference
               \code{KL} will estimate the divergence between \eqn{\theta - \delta} and
               \eqn{\theta + \delta} using \eqn{\theta + \delta} as the "true model."
               If \command{delta} is a vector, then \code{KL} will use recycling to make the length
               of \command{theta} and \command{delta} match. See \bold{Details} for more information.
}
}

\details{
The function \code{KL} returns item divergence and test divergence for the binary
response model (\option{"brm"}) and the graded response model (\option{"grm"}).  KL-divergence
is defined as the following:

\deqn{ KL(\theta_2 || \theta_1) = E_{\theta_2}\log\left[\frac{L(\theta_2)}{L(\theta_1)}\right]}{
       KL(\theta_2 || \theta_1) = E_{\theta_2}\log[L(\theta_2)/L(\theta_1)]}

where \eqn{L(\theta)} stands for the likelihood of \eqn{\theta}.  Essentially, KL-divergence
is the expected log-likelihood gain when using the true model in place of an alternative model.

For the binary response model, KL-divergence for an item simplifies to the following:

\deqn{ KL_j(\theta_2 || \theta_1)_j = p_j(\theta_2)\log\left[\frac{p_j(\theta_2)}{p_j(\theta_1)}\right] + [1 - p_j(\theta_2)]\log\left[\frac{1 - p_j(\theta_2)}{1 - p_j(\theta_1)}\right]}{
       KL_j(\theta_2 || \theta_1)_j = p_j(\theta_2)\log[p_j(\theta_2)/p_j(\theta_1)] + [1 - p_j(\theta_2)]\log[(1 - p_j(\theta_2))/(1 - p_j(\theta_1))]}

where \eqn{p_{ij}} is the probability of response, as indicated in the help page for \code{\link{simIrt}}

For the graded response model, KL-divergence for an item simplifies to the following:

\deqn{ KL_j(\theta_2 || \theta_1) = \sum_k{P_{jk}(\theta_2)\log\left[\frac{P_{jk}(\theta_2)}{P_{jk}(\theta_1)}\right]}}{
       KL_j(\theta_2 || \theta_1) = \sum_k{P_{jk}(\theta_2)\log[P_{jk}(\theta)2/P_{jk}(\theta_1)]}}

where \eqn{P_{jk}(\theta_2)} is the probability of \eqn{\theta_2} responding in category k as
indicated in the help page for \code{\link{simIrt}}. See Eggen (1999) as applied to classification
CAT and van der Linden and Pashley (2010) more generally.

Because of the properties of likelihood functions in item response models, test information
is simply the sum of the item informations, or:

\deqn{ KL(\theta_2 || \theta_1) = \sum_jKL_j(\theta_2 || \theta_1)}

\code{KL} is frequently used to select items in a classification CAT where the hypotheses (e.g. being
in one category versus another category are well defined).  If "being in the upper category" is
\eqn{\theta_2} and "being in the lower category" is \eqn{\theta_1}, then \eqn{\theta_2 = B + \delta}
and \eqn{\theta_1 = B - \delta} where \eqn{B} is the boundary separating the lower category from the
upper category.  Conversely, if using \code{KL} to select items in a precision CAT, then
\eqn{\theta_2 = \hat{\theta}_i + \delta} and \eqn{\theta_1 = \hat{\theta}_i} where \eqn{\hat{\theta}_i}
is the current, \emph{best} estimate of \eqn{\theta}. See \code{\link{catIrt}} for more information.
}

\value{
\code{KL}, \code{KL.brm}, and \code{KL.grm} return a list of the following elements:
  \item{item}{either: (1) a \eqn{N \times J} matrix of item information for each simulee to
              each item; (2) a \eqn{J}-length vector of item information for one simulee to
              each item; or (3) an \eqn{N}-length vector of item information for all simulees
              to one item, depending on the dimensions of \command{params}, \command{theta}, annd
              \command{delta}.
}
  \item{test}{an \eqn{N}-length vector of test information, one for each simulee. Test
              information is the sum of item information across items.  See \bold{Details} for
              more information.
}
}

\references{
Eggen, T. J. H. M.  (1999).  Item selection in adaptive testing with the sequential probability ratio test.  \emph{Applied Psychological Measurement}, \emph{23}, 249 -- 261.

Kullback, S., & Leibler, R. A.  (1951).  On information and sufficiency.  \emph{The Annals of Mathematical Statistics}, \emph{22}, 79 -- 86.

van dr Linden, W. J. & Pashley, P. J.  (2010).  Item selection and ability estimation in adaptive testing.  In W. J. van der Linden & C. A. W. Glas (Eds.), \emph{Elements of Adaptive Testing}.  New York, NY: Springer.
}

\author{
Steven W. Nydick \email{swnydick@gmail.com}
}

\note{
Kullback-Leibler divergence in IRT is not \emph{true} KL divergence, as the expectation
is with respect to a model that is not necessarily true.  Furthermore, it is not reciprocal,
as \eqn{KL(\theta_1 || \theta_2) \neq KL(\theta_2 || \theta_1)}.  There have been
other KL-based item selection measures proposed, including global information.  See
Eggen (1999) and \code{\link{itChoose}}.
}

\seealso{
\code{\link{catIrt}}, \code{\link{FI}}, \code{\link{itChoose}}, \code{\link{simIrt}}
}

\examples{
#########################
# Binary Response Model #
#########################

## 1 ##
set.seed(888)
# generating random theta:
theta <- rnorm(20)
# generating an item bank under a 3-parameter binary response model:
b.params <- cbind(a = runif(100, .5, 1.5), b = rnorm(100, 0, 2), c = .2)

# you can indicate class of params or extract it from simIrt object:
class(b.params) <- "brm"

# calculating KL information with delta = .1:
k.info1 <- KL(params = b.params, theta = theta, delt = .1)
# changing delta to .2
k.info2 <- KL(params = b.params, theta = theta, delt = .2)

# notice how the overall information has increased when increasing delt:
k.info1$test; k.info2$test

# also compare with Fisher information:
f.info <- FI(params = b.params, theta = theta, type = "expected")

k.info2$test; f.info$test

# Fisher information is much higher because of how it weighs things.

## 2 ##
# we can maximize information at a boundary - say "0":
k.info3 <- KL(params = b.params, theta = 0, delta = .1)
b.params[which.max(k.info3$item), ]

# notice how the a parameter is high while the b parameter is close to
# 0, so item selection is working.

# does Fisher information choose a different item?
f.info2 <- FI(params = b.params, theta = 0, type = "expected")
b.params[which.max(f.info2$item), ]

# nope - although with more items, who knows?


#########################
# Graded Response Model #
#########################

## 1 ##
set.seed(999)
# generating random theta
theta <- rnorm(20)
# generating an item bank under a graded response model:
g.params <- cbind(runif(100, .5, 1.5), rnorm(100), rnorm(100),
                                       rnorm(100), rnorm(100), rnorm(100))
# simulating responses (so that the parameters are ordered - see simIrt)
g.params <- simIrt(theta = theta, params = g.params, mod = "grm")$params[ , -1]

# we can calculate KL information as before, noting that class(g.params) is "grm"
class(g.params)     # so we don't need to set it ourselves

# and now KL info with delt = .1
k.info4 <- KL(theta = theta, params = g.params)

# KL information is higher when more boundaries
k.info4$test
k.info1$test

# Note: k.info1 would be exactly the same if calculated with the "grm"
#       rather than the "brm"

## 2 ##
# we can also maximize information at boundary "0"
k.info5 <- KL(params = g.params, theta = 0, delta = .1)
g.params[which.max(k.info5$item), ]

# notice how the a parameter is high while the b parameters are pretty spread out.

# does Fisher information choose a different item?
f.info3 <- FI(params = g.params, theta = 0, type = "expected")
g.params[which.max(f.info3$item), ]

# nope - although with more items, who knows?
}
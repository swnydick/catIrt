\name{mleEst}
\alias{mleEst}
\alias{wleEst}
\alias{bmeEst}
\alias{eapEst}

\title{Estimate Ability in IRT Models}

\description{
\code{mleEst}, \code{wleEst}, \code{bmeEst}, and \code{eapEst} estimate
ability in IRT models. \code{mleEst} is Maximum Likelihood Information, \code{wleEst} is
Weighted Likelihood Information (see \bold{Details}), \code{bmeEst} is
Bayesian-Modal Estimation, and \code{eapEst} is Expected-A-Posterior Estimation.
}

\usage{
mleEst( resp, params, range = c(-6, 6), mod = c("brm", "grm"), \dots )
wleEst( resp, params, range = c(-6, 6), mod = c("brm", "grm"), \dots )
bmeEst( resp, params, range = c(-6, 6), mod = c("brm", "grm"),
        ddist = dnorm, \dots )
eapEst( resp, params, range = c(-6, 6), mod = c("brm", "grm"),
        ddist = dnorm, quad = 33, \dots )
}

\arguments{
  \item{resp}{\bold{numeric:} either a \eqn{N \times J} matrix (where \eqn{N} indicates the
              number of simulees and \eqn{J} indicates the number of items), a
              \eqn{N} length vector (if there is only one item) or a \eqn{J} length
              vector (if there is only one simulee).  For the binary response model
              (\option{"brm"}), \command{resp} must solely contain 0s and 1s.  For the
              graded response model (\option{"grm"}), \command{resp} must solely contain
              integers \eqn{1, \ldots, K}, where \eqn{K} is the number of categories, as
              indicated by the dimension of \command{params}.
}
  \item{params}{\bold{numeric:} a vector or matrix of item parameters.  If specified
                as a matrix, the rows must index the items, and the columns
                must designate the item parameters.
}
  \item{range}{\bold{numeric:} a two-element numeric vector indicating the minimum and maximum over
               which to optimize a likelihood function (\code{mleEst}) or posterior distribution
               (\code{bmeEst}), find roots to a score function (\code{wleEst}), or integrate
               over (\code{eapEst}).
}
  \item{mod}{\bold{character:} a character string indicating the IRT model.  Current support
             is for the 3-parameter binary response model (\option{"brm"}),
             and Samejima's graded response model (\option{"grm"}).
             See \code{\link{simIrt}} for more information.
}
  \item{ddist}{\bold{function:} a function that calculates prior densities for Bayesian
               estimation.  For instance, if you wish to specify a normal prior, \code{ddist = dnorm},
               and if you wish to specify a uniform prior, \code{ddist = dunif}.  Note that
               it is standard in R to use \code{d}\ldots to indicate a density.
}
  \item{quad}{\bold{numeric:} a scalar indicating the number of quadrature points when
              using \code{eapEst}.  See \bold{Details} for more information.
}
  \item{\dots}{arguments passed to \command{ddist}, usually distribution parameters
               identified by name.
}
}

\details{
These functions return estimated "ability" for the binary response model (\option{"brm"})
and the graded response model (\option{"grm"}).  The only difference between the functions
is how they estimate ability.

The function \code{mleEst} searches for a maximum of the log-likelihood with respect to
each individual \eqn{\theta_i} and uses \eqn{[T(\theta)]^{-1/2}} as the corresponding standard
error of measurement (SEM), where \eqn{T(\theta)} is the observed test information function
at \eqn{\theta}, as described in \code{\link{FI}}.

The function \code{bmeEst} searches for the maximum of the log-likelihood after a
log-prior is added, which effectively maximizes the posterior distribution for each
individual \eqn{\theta_i}.  The SEM of the \code{bmeEst} estimator uses the well known
relationship (Keller, 2000, p. 10)

\deqn{V[\theta | \boldsymbol{u}_i]^{-1} = T(\theta) - \frac{\partial \log[p(\theta)]}{\partial \theta^2}}{
      V[\theta | u_i]^{-1} = T(\theta) - d l[p(\theta)]/d\theta^2}

where \eqn{V[\theta | \boldsymbol{u}_i]}{V[\theta | u_i]} is the variance of \eqn{\theta} after
taking into consideration the prior distribution and \eqn{p(\theta)} is the prior distribution
of \eqn{\theta}.  The function \code{bmeEst} estimates the second derivative of the prior
distribution uses the \code{hessian} function in the \code{numDeriv} package.

The function \code{wleEst} searches for the root of a modified score function (i.e.
the first derivative of the log-likelihood with something added to it).  The modification
corrects for bias in fixed length tests, and estimation using this modification results in
what is called Weighted Maximum Likelihood (or alternatively, the Warm estimator) (see Warm,
1989).  So rather than maximizing the likelihood, \code{wleEst} finds a root of:

\deqn{ \frac{\partial l(\theta)}{\partial \theta} + \frac{H(\theta)}{2I(\theta)}}{
        d l(\theta)/d\theta + H(\theta)/[2I(\theta)]}

where \eqn{l(\theta)} is the log-likelihood of \eqn{\theta} given a set of responses
and item parameters, \eqn{I(\theta)} is expected test information to this point,
and \eqn{H(\theta)} is a correction constant defined as:

\deqn{ H(\theta) = \sum_j\frac{p_{ij}^{\prime}p_{ij}^{\prime\prime}}{p_{ij}[1 - p_{ij}]}}{
       H(\theta) = \sum_j[p_{ij}'p_{ij}''/[p_{ij}(1 - p_{ij})]}

for the binary response model, where \eqn{p_{ij}^{\prime}}{p_{ij}'} is the first derivative
of \eqn{p_{ij}} with respect to \eqn{\theta}, \eqn{p_{ij}^{\prime\prime}}{p_{ij}''} is
the second derivative of \eqn{p_{ij}} with respect to \eqn{\theta}, and \eqn{p_{ij}} is the
probability of response, as indicated in the help page for \code{\link{simIrt}}, and

\deqn{ H(\theta) = \sum_j\sum_k\frac{P_{ijk}^{\prime}P_{ijk}^{\prime\prime}}{P_{ijk}}}{
       H(\theta) = \sum_j\sum_k[P_{ijk}'P_{ijk}''/P_{ijk}]}

for the graded response model, where \eqn{P_{ijk}^{\prime}}{P_{ijk}'} is the first derivative
of \eqn{P_{ijk}} with respect to \eqn{\theta}, \eqn{P_{ijk}^{\prime\prime}}{P_{ijk}''} is
the second derivative of \eqn{P_{ijk}}, and \eqn{P_{ijk}} is the probability of responding
in category k as indicated in the help page for \code{\link{simIrt}}.  The SEM of the \code{wleEst}
estimator uses an approximation based on Warm (1989, p. 449):

\deqn{ V(\theta) \approx \frac{T(\theta) + \frac{H(\theta)}{2I(\theta)}}{T^2(\theta)}}{
       V(\theta) \approx (T(\theta) + H(\theta)/[2I(\theta)])/T^2(\theta).}

The function \code{eapEst} finds the mean and standard deviation of the posterior distribution
given the log-likelihood, a prior distribution (with specified parameters), and the number of
quadrature points using the standard Bayesian identity with summations in place of integrations
(see Bock and Mislevy, 1982). Rather than using the adaptive, quadrature based \code{integrate},
\code{eapEst} uses the flexible \code{integrate.xy} function in the \code{sfsmisc} package. 
As long as the prior distribution is reasonable (such that the joint distribution is relatively smooth),
this method should work.
}

\value{
\code{mleEst}, \code{wleEst}, \code{bmeEst}, and \code{eapEst} return a list of the
following elements:
  \item{theta}{an \eqn{N}-length vector of ability values, one for each simulee.
}
  \item{info}{an \eqn{N}-length vector of observed test information, one for each simulee.
             Test information is the sum of item information across items.  See \code{\link{FI}}
             for more information.
}
  \item{sem}{an \eqn{N}-length vector of observed standard error of measurement (or posterior standard
             deviation) for each simulee.  See \code{\link{FI}} for more information.
}
}

\references{
Bock, R. D., & Mislevy, R. J.  (1982).  Adaptive EAP estimation of ability in a microcomputer environment.  \emph{Applied Psychological Measurement}, \emph{6}, 431 -- 444.

Embretson, S. E., & Reise, S. P.  (2000).  \emph{Item Response Theory for Psychologists}.  Mahway, NJ: Lawrence Erlbaum Associates.

Keller (2000).  \emph{Ability estimation procedures in computerized adaptive testing} (Technical Report).  New York, NY: American Institute of Certified Public Accountants.

Warm, T. A.  (1989).  Weighted likelihood estimation of ability in item response theory.  \emph{Psychometrika}, \emph{54}, 427 -- 450.

van dr Linden, W. J. & Pashley, P. J.  (2010).  Item selection and ability estimation in adaptive testing.  In W. J. van der Linden & C. A. W. Glas (Eds.), \emph{Elements of Adaptive Testing}.  New York, NY: Springer.
}

\author{
Steven W. Nydick \email{swnydick@gmail.com}
}

\note{
For the binary response model (\option{"brm"}), it makes no sense to estimate
ability with a non-mixed response pattern (all 0s or all 1s).  The user might want
to include enough items in the model to allow for reasonable estimation.

Weighted likelihood estimation (\code{wleEst}) uses \code{uniroot} to find the root
of the modified score function, so that the end points of \option{range} must evaluate
to opposite signs (or zero).  Rarely, the end points of \option{range} will evaluate
to the same sign, so that \code{uniroot} will error.  In these cases, uniroot will
extend the interval until the end points of the (modified) range are opposite signs.
}

\seealso{
\code{\link{catIrt}}, \code{\link{simIrt}},
\code{\link[numDeriv]{hessian}}, \code{\link[stats]{uniroot}}
}

\examples{
\dontrun{

#########################
# Binary Response Model #
#########################
set.seed(888)
# generating random theta:
theta <- rnorm(201)
# generating an item bank under a 2-parameter binary response model:
b.params <- cbind(a = runif(100, .5, 1.5), b = rnorm(100, 0, 2), c = 0)
# simulating responses using specified theta:
b.resp <- simIrt(theta = theta, params = b.params, mod = "brm")$resp


# estimating theta using all four methods:
est.mle1 <- mleEst(resp = b.resp, params = b.params, mod = "brm")$theta
est.wle1 <- wleEst(resp = b.resp, params = b.params, mod = "brm")$theta
est.bme1 <- bmeEst(resp = b.resp, params = b.params, mod = "brm",
                   ddist = dnorm, mean = 0, sd = 1)$theta
est.eap1 <- eapEst(resp = b.resp, params = b.params, mod = "brm",
                   ddist = dnorm, mean = 0, sd = 1, quad = 33)$theta

# eap takes a while!

# all of the methods are highly correlated:
cor(cbind(theta = theta, mle = est.mle1, wle = est.wle1,
                         bme = est.bme1, eap = est.eap1))

# you can force eap to be positive:
est.eap2 <- eapEst(resp = b.resp, params = b.params, range = c(0, 6),
                                  mod = "brm", ddist = dunif, min = 0, max = 6)$theta

est.eap2

# if you only have a single response, MLE will give junk!
mleEst(resp = 0, params = c(1, 0, .2), mod = "brm")$theta

# the others will give you answers that are not really determined by the response:
wleEst(resp = 0, params = c(1, 0, .2), mod = "brm")$theta
bmeEst(resp = 0, params = c(1, 0, .2), mod = "brm")$theta
eapEst(resp = 0, params = c(1, 0, .2), mod = "brm")$theta


#########################
# Graded Response Model #
#########################
set.seed(999)
# generating random theta
theta <- rnorm(400)
# generating an item bank under a graded response model:
g.params <- cbind(a = runif(100, .5, 1.5), b1 = rnorm(100), b2 = rnorm(100),
                                           b3 = rnorm(100), b4 = rnorm(100))
# simulating responses using random theta:
g.mod <- simIrt(params = g.params, theta = theta, mod = "grm")

# pulling out the responses and the parameters:
g.params2 <- g.mod$params[ , -1]       # now the parameters are sorted
g.resp2 <- g.mod$resp

# estimating theta using all four methods:
est.mle3 <- mleEst(resp = g.resp2, params = g.params2, mod = "grm")$theta
est.wle3 <- wleEst(resp = g.resp2, params = g.params2, mod = "grm")$theta
est.bme3 <- bmeEst(resp = g.resp2, params = g.params2, mod = "grm",
                   ddist = dnorm, mean = 0, sd = 1)$theta
est.eap3 <- eapEst(resp = g.resp2, params = g.params2, mod = "grm",
                   ddist = dnorm, mean = 0, sd = 1, quad = 33)$theta

# and the correlations are still pretty high:
cor(cbind(theta = theta, mle = est.mle3, wle = est.wle3,
                         bme = est.bme3, eap = est.eap3))

# note that the graded response model is just a generalization of the brm:
cor(est.mle1, mleEst(resp = b.resp + 1, params = b.params[ , -3], mod = "grm")$theta)
cor(est.wle1, wleEst(resp = b.resp + 1, params = b.params[ , -3], mod = "grm")$theta)
cor(est.bme1, bmeEst(resp = b.resp + 1, params = b.params[ , -3], mod = "grm")$theta)
cor(est.eap1, eapEst(resp = b.resp + 1, params = b.params[ , -3], mod = "grm")$theta)

}

}

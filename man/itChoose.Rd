\name{itChoose}
\alias{itChoose}
\title{Choose the Next Item in a CAT}
\description{
\code{itChoose} chooses the next item in a CAT based on the
remaining items and a variety of item selection algorithms.
}

\usage{
itChoose( left_par, mod = c("brm", "grm"), 
          numb = 1, n.select = 1,
          cat_par = NULL, cat_resp = NULL, cat_theta = NULL,
          select = c("UW-FI", "LW-FI", "PW-FI",
                     "FP-KL", "VP-KL", "FI-KL", "VI-KL",
                     "random"),
          at = c("theta", "bounds"),
          range = c(-6, 6), it.range = NULL,
          delta = NULL, bounds = NULL,
          ddist = dnorm, quad = 33, ... )
}

\arguments{
  \item{left_par}{\bold{numeric:} a matrix of item parameters from which to choose
                 the next item.  The rows must index the items, and the columns must
                 designate the item parameters (in the appropriate order, see 
                 \code{\link{catIrt}}).  The first column of \command{left_par} must
                 indicate the \emph{item numbers}, as \code{itChoose} returns not
                 \emph{just} the item parameters but also the bank number corresponding
                 to those parameters.  See \bold{Details} for more information.
}
  \item{mod}{\bold{character:} a character string indicating the IRT model.  Current support
             is for the 3-parameter binary response model (\option{"brm"}),
             and Samejima's graded response model (\option{"grm"}).  The contents
             of \command{params} must match the designation of \command{mod}.  See
             \code{\link{catIrt}} or \code{\link{simIrt}} for more information.
}
  \item{numb}{\bold{numeric:} a scalar indicating the number of items to \emph{return} to
             the user.  If \command{numb} is less than \command{n.select}, then
             \code{itChoose} will randomly select \command{numb} items from the top
             \command{n.select} items according to the item selection algorithm.
}

  \item{n.select}{\bold{numeric:} an \emph{integer} indicating the number of items to randomly select 
                  between at one time.  For instance, if \command{select} is \option{"UW-FI"}, 
                  \command{at} is \option{"theta"}, \command{numb} is 3, and \command{n.select} is 8, 
                  then \code{itChoose} will randomly select \emph{3} items out of the top \emph{8} 
                  items that maximize Fisher information at \command{cat_theta}.
}
  \item{cat_par}{\bold{numeric:} either NULL or a matrix of item parameters that have already
                been administered in the CAT.  \command{cat_par} only needs to be specified
                if letting \command{select} equal either \option{"LW-FI"}, \option{"PW-FI"},
                \option{"VP-KL"} or \option{"VI-KL"}.  The format of \command{cat_par} must be the
                same as the format of \command{left_par}. See \bold{Details} for more information.
}
  \item{cat_resp}{\bold{numeric:} either NULL or a vector of responses corresponding to the items 
                 specified in \command{cat_par}.  \command{cat_par} only needs to be specified if
                 letting \command{select} equal either \option{"LW-FI"} or \option{"PW-FI"}.
}
  \item{cat_theta}{\bold{numeric:} either NULL or a scalar corresponding to the current ability
                  estimate.  \command{cat_theta} is not needed if selecting items at \option{"bounds"}
                  or using \option{"LW-FI"} or \option{"PW-FI"} as the item selection algorithm.
}
  \item{select}{\bold{character:} a character string indicating the desired item selection 
               method.  Items can be selected either through maximum Fisher information or
               Kullback-Leibler divergence methods or randomly.  The Fisher information methods
               include

  \itemize{
    \item \option{"UW-FI"}: unweighted Fisher information at a point.
    \item \option{"LW-FI"}: Fisher information weighted across the likelihood function.
    \item \option{"PW-FI"}: Fisher information weighted across the posterior distribution of
          \eqn{\theta}.
  }

              And the Kullback-Leibler divergence methods include

  \itemize{
    \item \option{"FP-KL"}: pointwise KL divergence between [P +/- delta], where
           P is either the current \eqn{\theta} estimate or a classification bound.
    \item \option{"VP-KL"}: pointwise KL divergence between [P +/- delta/sqrt(n)], where
           n is the number of items given to this point in the CAT.
    \item \option{"FI-KL"}: KL divergence integrated along [P -/+ delta] with respect to P
    \item \option{"VI-KL"}: KL divergence integrated along [P -/+ delta/sqrt(n)] with
           respect to P.
  }
    
      See \bold{Details} for more information.
}
  \item{at}{\bold{character:} a character string indicating where to select items.
}
  \item{range}{\bold{numeric:} a 2-element numeric vector indicating the range of values
              that \code{itChoose} should average over if \command{select} equals
              \option{"LW-FI"} or \option{"PW-FI"}.
}
  \item{it.range}{\bold{numeric:} Either a 2-element numeric vector indicating the minimum
                  and maximum allowed difficulty parameters for selected items (only if \command{mod}
                  is equal to \option{"brm"}) or NULL indicating no item parameter restrictions.
}
  \item{delta}{\bold{numeric:} a scalar indicating the multiplier used in item selection
              if a Kullback-Leibler method is chosen.  For fixed-point KL divergence,
              \command{delta} is frequently .1 or .2, whereas in variable-point KL divergence,
              \command{delta} usually corresponds to 95 or 97.5 percentiles on a normal distribution.
}
  \item{bounds}{\bold{numeric:} a vector of fixed-points/bounds from which to select items
               if \command{at} equals \option{"bounds"}.
}
  \item{ddist}{\bold{function:} a function indicating how to calculate prior densities
              if \command{select} equals \option{"PW-FI"} (i.e., weighting Fisher information
              on the posterior distribution).  See \code{\link{catIrt}} for more information.
}
  \item{quad}{\bold{numeric:} a scalar indicating the number of quadrature points when
              \command{select} equals \option{"LW-FI"} or \option{"PW-FI"}.  See \bold{Details}
              for more information.
}
  \item{\dots}{arguments passed to \command{ddist}, usually distribution parameters identified by name.
}
}

\details{
The function \code{itChoose} returns the next item(s) to administer in a CAT environment.
The item selection algorithms fall into three major types: Fisher information, Kullback-Leibler
divergence, and random.

\itemize{
  \item If choosing items based on Fisher information (\command{select} equals \option{"UW-FI"},
        \option{"LW-FI"}, or \option{"PW-FI"}), then items are selected based on some aggregation
        of Fisher information (see \code{\link{FI}}).  The difference between the three Fisher information
        methods are the weighting functions used (see van der Linden, 1998; Veerkamp & Berger, 1997).  Let

\deqn{ I(w_{ij} | a_j, b_j, c_j) = \int_{-\infty}^{\infty} w_{ij}I_j(\theta)\mu(d\theta) }

        be the "average" Fisher information, weighted by real valued function \eqn{w_{ij}}.  Then
        all three Fisher information criteria can be explained solely as using different
        weights.  Unweighted Fisher information (\option{"UW-FI"}) sets \eqn{w_{ij}} equal to a Dirac
        delta function with all of its mass either on \command{theta} (if \command{at} equals
        \option{"theta"}) or the nearest classification bound (if \command{at} equals \option{"bounds"}).
        Likelihood-Weighted Fisher information (\option{"UW-FI"}) sets \eqn{w_{ij}} equal to the likelihood
        function given all of the previously administered items (Veerkamp & Berger, 1997).  And
        Posterior-Weighted Fisher information (\option{"PW-FI"}) sets \eqn{w_{ij}} equal to the likelihood
        function times the prior distribution specified in \command{ddist} (van der Linden, 1998).  All
        three algorithms select items based on maximizing the respective criterion with \option{"UW-FI"}
        the most popular CAT item selection algorithm and equivalent to maximizing Fisher information
        at a point (Pashley & van der Linden, 2010).
  \item If choosing items based on Kullback-Leibler divergence (\command{select} equals \option{"FP-KL"},
        \option{"VP-KL"}, \option{"FI-KL"}, or \option{"VI-KL"}), then items are selected based on
        some aggregation of KL divergence (see \code{\link{KL}}).

  \itemize{
    \item The Pointwise KL divergence criteria (\command{select} equals \option{"FP-KL"} and 
           \option{"VP-KL"}) compares KL divergence at two points:

\deqn{ KL(w_{ij} | a_j, b_j, c_j) = KL_j(P + w_{ij} || P - w_{ij}) }

          The difference between \option{"FP-KL"} and \option{"VP-KL"} are the weights used.  Fixed
          Pointwise KL divergence (\option{"FP-KL"}) sets \eqn{w_{ij}} equal to \option{delta}, and
          Variable Pointwise KL divergence (\option{"VP-KL"}) sets \eqn{w_{ij}} equal to \option{delta}
          multiplied by \eqn{1/\sqrt{n}}, where \eqn{n} is equal to the number of items given to
          this point in the CAT (see Chang & Ying, 1996).

    \item The Integral KL divergence criteria (\command{select} equals \option{"FI-KL"} and
          \option{"VI-KL"}) integrates KL divergence across a small area:

\deqn{ KL(w_{ij} | a_j, b_j, c_j) = \int_{P - w_{ij}}^{P + w_{ij}} KL_j(\theta || P) d\theta }
    
          As in Pointwise KL divergence, Fixed Integral KL divergence (\option{"FI-KL"}) sets
          \eqn{w_{ij}} equal to \option{delta}, and Variable Integral KL divergence (\option{"VI-KL"})
          sets \eqn{w_{ij}} equal to \option{delta} multiplied by \eqn{1/\sqrt{n}} (see Chang & Ying, 1996).

  }

          All KL divergence criteria set \eqn{P} equal to \command{theta} (if \command{at} equals
          \option{"theta"}) or the nearest classification bound (if \command{at} equals \option{"bounds"})
          and select items based on maximizing the respective criterion.

  \item If \command{select} is \option{"random"}, then \code{itChoose} randomly picks the next item(s)
        out of the remaining items in the bank.
}
}

\value{
\code{itChoose} returns a list of the following elements:
  \item{params}{a matrix corresponding to the next item or \command{numb} items to administer
                in a CAT with the first column indicating the item number
}
  \item{info}{a vector of corresponding information for the \command{numb} items of
              \command{params}. 
}
  \item{type}{the type of information returned in \command{info}, which is equal to the
              item selection algorithm.
}
}

\references{
Chang, H.-H., & Ying, Z.  (1996).  A global information approach to computerized adaptive testing.  \emph{Applied Psychological Measurement}, \emph{20}, 213 -- 229.

Pashley, P. J., & van der Linden, W. J.  (2010).  Item selection and ability estimation in adaptive testing.  In W. J. van der Linden & C. A. W. Glas (Eds.), \emph{Elements of adaptive testing} (pp. 3 -- 30).  New York, NY: Springer.

van der Linden, W. J.  (1998).  Bayesian item selection criteria for adaptive testing.  \emph{Psychometrika}, \emph{63}, 201 -- 216.

Veerkamp, W. J. J., & Berger, M. P. F.  (1997).  Some new item selection criteria for adaptive testing.  \emph{Journal of Educational and Behavioral Statistics}, \emph{22}, 203 -- 226.
}

\author{
Steven W. Nydick \email{nydic001@umn.edu}
}

\seealso{
\code{\link{catIrt}}, \code{\link{FI}}, \code{\link{KL}},
\code{\link{mleEst}}, \code{\link{simIrt}}
}

\examples{
#########################
# Binary Response Model #
#########################
\dontrun{
set.seed(888)
# generating an item bank under a binary response model:
b.params <- cbind(a = runif(100, .5, 1.5), b = rnorm(100, 0, 2), c = .2)
# simulating responses using default theta:
b.mod <- simIrt(theta = 0, params = b.params, mod = "brm")

# separating the items into "administered" and "not administered":
left_par <- b.mod$params[1:95, ]
cat_par <- b.mod$params[96:100, ]
cat_resp <- b.mod$resp[ , 96:100]

# running simIrt automatically adds the item numbers to the front!

# attempting each item selection algorithm (except random):
uwfi.it <- itChoose(left_par = left_par, mod = "brm",
                    numb = 1, n.select = 1,
                    cat_theta = 0,
                    select = "UW-FI",
                    at = "theta")
lwfi.it <- itChoose(left_par = left_par, mod = "brm",
                    numb = 1, n.select = 1,
                    cat_par = cat_par, cat_resp = cat_resp,
                    select = "LW-FI")
pwfi.it <- itChoose(left_par = left_par, mod = "brm",
                    numb = 1, n.select = 1,
                    cat_par = cat_par, cat_resp = cat_resp,
                    select = "PW-FI", ddist = dnorm, mean = 0, sd = 1)

fpkl.it <- itChoose(left_par = left_par, mod = "brm",
                    numb = 1, n.select = 1,
                    cat_theta = 0,
                    select = "FP-KL",
                    at = "theta", delta = 1.96)
vpkl.it <- itChoose(left_par = left_par, mod = "brm",
                    numb = 1, n.select = 1,
                    cat_par = cat_par, cat_theta = 0,
                    select = "VP-KL",
                    at = "theta", delta = 1.96)
fikl.it <- itChoose(left_par = left_par, mod = "brm",
                    numb = 1, n.select = 1,
                    cat_theta = 0,
                    select = "FI-KL",
                    at = "theta", delta = 1.96)
vikl.it <- itChoose(left_par = left_par, mod = "brm",
                    numb = 1, n.select = 1,
                    cat_par = cat_par, cat_theta = 0,
                    select = "VI-KL",
                    at = "theta", delta = 1.96)

# which items were the most popular?
uwfi.it$params  # 61 (b close to 0)
lwfi.it$params  # 55 (b close to -2.5)
pwfi.it$params  # 16 (b close to -0.5)
fpkl.it$params  # 61 (b close to 0)
vpkl.it$params  # 61 (b close to 0)
fikl.it$params  # 16 (b close to -0.5)
vikl.it$params  # 16 (b close to -0.5)

# if we pick the top 10 items for "FI-KL":
fikl.it2 <- itChoose(left_par = left_par, mod = "brm",
                     numb = 10, n.select = 10,
                     cat_theta = 0,
                     select = "FI-KL",
                     at = "theta", delta = 1.96)

# we find that item 61 is the third best item
fikl.it2$params

# why did "LW-FI" pick an item with a strange difficulty?
cat_resp

# because cat_resp is mostly 0 ...
# --> so the likelihood is weighted toward negative numbers.

#########################
# Graded Response Model #
#########################
set.seed(999)
# generating an item bank under a graded response model:
g.params <- cbind(runif(100, .5, 1.5), rnorm(100), rnorm(100),
                                       rnorm(100), rnorm(100), rnorm(100))
# simulating responses (so that the parameters are ordered - see simIrt)
left_par <- simIrt(theta = 0, params = g.params, mod = "grm")$params

# now we can choose the best item for theta = 0 according to FI:
uwfi.it2 <- itChoose(left_par = left_par, mod = "brm",
                     numb = 1, n.select = 1,
                     cat_theta = 0,
                     select = "UW-FI",
                     at = "theta")
uwfi.it2
}

}

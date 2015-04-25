\name{NEWS}
\title{Changes/Updates to the catIrt Package}

\section{Changes in version 0.5-0}{
  \itemize{
    \item Wrote all of the probability and derivatives of probability functions
          in C for speed and code clarity.

    \item Wrote a quick integration function (that takes function arguments) to calculate
          Sympson's rule and a quick integration function (that takes vector arguments)
          to calculate the trapezoidal rule.  The former is now implemented in eapEst,
          and the latter is implemented to calculate weighted Fisher and KL information
          for itChoose.

    \item Changed simIrt to calculate probabilities in C before simulating responses
          (rather than calculating probabilities and simulating responses at the
          same time).  This change can result in a slightly different matrix of
          responses to items due to the alteration of simulation order.

    \item Changed FI and KL functions so that item information would be presented in a
          person by item dimension matrix rather than an item by person dimension
          matrix.

    \item Fixed a bug in catIrt, so that if in non-interactive/batch mode, the CAT
          would not automatically set n.max to nrow(params).

    \item Fixed a bug in print.catIrt, so that it would display the correct
          precision-based stopping rule.
  }
}

\section{Changes in version 0.4-3}{
  \itemize{
    \item Fixed a bug in wleEst, so that the interval would naturally extend if the
          first derivative of the log-likelihood evaluated to the same sign.
  }
}

\section{Changes in version 0.4-2}{
  \itemize{
    \item Fixed manual links to be consistent with updates to the catR package, namely
          the deletion of the createItemBank function.

    \item Fixed another bug in WFI (weighted Fisher information), so that it would not error
          if only 0-1 items had been taken in the CAT.
  }
}

\section{Changes in version 0.4-1}{
  \itemize{
    \item Added NEWS.Rd to be compatible with R's news function.

    \item Made sure that a new line would appear if progress = TRUE.

    \item Fixed a bug in WFI (weighted Fisher information), so that it would not error
          if only 0-1 items had been taken in the CAT.
  }
}

\section{Changes in version 0.4-0}{
  \itemize{
    \item Added "it.range" argument to the catStart/catMiddle list and to the itChoose
          function to restrict the difficulty parameters (in a binary response model)
          to be within a particular range.

    \item Changed some code to be neater, cleaner, etc.

    \item Fixed a bug in catIrt, so that letting catStart$n.select or catMiddle$n.select
          be anything other than 1 would actually select between the top "n.select" items.

    \item Fixed a bug in simIrt so that the parameters did not need to have
          column names for the function to correctly work.

    \item Fixed a bug in termGLR, so that the stopping rule would use the "range"
          sub-argument of catMiddle rather than the depricated "int" sub-argument to
          calculate the likelihoods.

    \item Fixed a bug in termCI, so that the stopping rule would only consider the
          last value of SEM when forming a confidence interval.

    \item Fixed a small bug in print.summary.catIrt, so that the function would check
          the n.start argument of catStart (rather than the n.it argument) to determine
          how many starting items that the CAT administered.

    \item Fixed several bugs in catMiddle, so that the CAT would choose the starting
          scoring method if the MLE wasn't achieved (and catMiddle$select = "MLE"),
          and wouldn't error if the starting scoring method was "step".

    \item Fixed a bug whereby the catIrt function was not adequately determining
          if the first vector of item parameters was the item number.  Now,
          the item number can ONLY be attached if the parameters are outputted from
          a catIrt function.
  }
}

\section{Changes in version 0.3-0}{
  \itemize{
    \item Added more termination criteria, including when the Fisher Information
          exceeds a particular threshold or when either the Fisher Information or
          SEM change less than a particular amount.  Note that the original v.term
          argument is now obsolete and replaced with p.term and i.term arguments.

    \item Added WFI (Weighted Fisher Information) function (not exported) and added
          two item selection criteria (Posterior WFI and Likelihood WFI) which both
          use the WFI function.

    \item Added IKL (Integrated KL Divergence) function (not exported) and added
          two item selection criteria (Fixed Integral KL and Variable Integral KL)
          which both use the IKL function.

    \item Changed the arguments to itChoose and exported the function so that anybody
          can use itChoose in his/her own CAT algorithm.

    \item Changed simIrt to return params with the item numbers cbind-ed onto the front
          of them, which is required for the itChoose function.

    \item The "var" option of catTerm$term no longer exists and is replaced with
          "precision" and "info".

    \item Changed catMiddle$int to catMiddle$range to reduce confusion.

    \item Changed the argument CI to conf.lev in plot.catIrt so that catIrt and
          plot.catIrt have consistent names for confidence intervals.

    \item Changed thetas in catIrt and simIrt to theta to keep consistency with other
          functions.

    \item Changed catStart$init.thet to catStar$init.theta to reduce confusion.

    \item Plotting the individual CAT progression is more customizable.

    \item The bank info functions/SEM functions are no longer able to be customized
          to prevent plotting conflicts.

    \item Exported [.mod and [<-.mod functions outside of the catIrt function, where
          mod is any of the IRT models.

    \item Changed a lot of the manual entries for clarity and consistency, and added a
          manual entry for the itChoose function.

    \item Fixed the SEM for WLE/BME/EAP estimation to be appropriate for the particular
          estimation methods, and added numDeriv as a required package for BME
          variance estimation.
  }
}

\section{Changes in version 0.2-1}{
  \itemize{
    \item The format of the catIrt input function was rewritten a bit.

    \item Rather than putting everything as arguments into catSim,
          modules (startCat, middleCat, termCat) were created so that the
          package can be easily updated in the future.

    \item A Sympson-Hetter addendum to the catIrt function was added, in the hope
          of eventually writting a Sympson-Hetter function.

    \item The simple version of the GLR stopping rule was added for classification
          CAT rather than just the original SPRT method.

    \item The confidence interval stopping rule was added for classification CAT.

    \item The call was deleted to the output of catIrt because the process of updating
          the function is too tedious to make it worth while.

    \item Added an option for theta estimation from the full bank of items.  If
          EAP was selected and failed to estimate theta (due to underflow),
          full-test estimation proceeds using the BME method.
  }
}

\section{Changes in version 0.1-1}{
  \itemize{
    \item Most of the functions were completely rewritten for speed.

    \item summary.catIrt and plot.catIrt were rewritten, and print commands were 
          added.
	
	\item summary.catIrt and print.catIrt now can display each simulees CAT
          progression.
		
	\item S3 method FI was added to make the code clearer.
	
	\item S3 classes "brm" and "grm" were added, and class "cat" was changed to 
          class "catIrt."
	
	\item The argument "int" was added to catIrt, and a tiny bit of code was 
          rewritten so that cat.thet estimates could not exceed int on either side.

    \item The call was added to the output of catIrt so that the update command
          would work.

    \item The eapSE command was added, and now catIrt gives the posterior
          standard deviation if score = "EAP".
  }
}

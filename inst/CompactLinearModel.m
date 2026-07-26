## Copyright (C) 2026 Avanish Salunke <avanishsalunke16@gmail.com>
##
## This file is part of the statistics package for GNU Octave.
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

classdef CompactLinearModel

  properties(GetAccess = public, SetAccess = protected)

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} CoefficientCovariance
    ##
    ## Covariance matrix of coefficient estimates
    ##
    ## A @math{p}-by-@math{p} numeric matrix of covariance values for the
    ## coefficient estimates, where @math{p} is the number of coefficients in
    ## the fitted model as given by @code{NumCoefficients}.  This property is
    ## read-only.
    ##
    ## @end deftp
    CoefficientCovariance = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} CoefficientNames
    ##
    ## Coefficient names
    ##
    ## A cell array of character vectors, each containing the name of the
    ## corresponding model term (e.g., @qcode{'(Intercept)'}, @qcode{'x1'},
    ## @qcode{'x1:x2'}).  This property is read-only.
    ##
    ## @end deftp
    CoefficientNames = {};

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} Coefficients
    ##
    ## Coefficient values
    ##
    ## A table with one row for each coefficient and four columns:
    ## @itemize
    ## @item @code{Estimate} - estimated coefficient value
    ## @item @code{SE} - standard error of the estimate
    ## @item @code{tStat} - t-statistic for a two-sided test
    ## @item @code{pValue} - p-value for the t-statistic
    ## @end itemize
    ## Coefficients that are dropped due to rank deficiency have
    ## @code{Estimate = 0}, @code{SE = 0}, @code{tStat = NaN},
    ## @code{pValue = NaN}.  This property is read-only.
    ##
    ## @end deftp
    Coefficients = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} NumCoefficients
    ##
    ## Number of model coefficients
    ##
    ## A positive integer giving the total number of coefficients in the fitted
    ## model, including any coefficients set to zero because the model terms are
    ## rank deficient.  This property is read-only.
    ##
    ## @end deftp
    NumCoefficients = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} NumEstimatedCoefficients
    ##
    ## Number of estimated coefficients
    ##
    ## A positive integer giving the number of coefficients actually estimated,
    ## i.e., not set to zero due to rank deficiency.
    ## @code{NumEstimatedCoefficients} equals the degrees of freedom for
    ## regression.  This property is read-only.
    ##
    ## @end deftp
    NumEstimatedCoefficients = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} DFE
    ##
    ## Degrees of freedom for error
    ##
    ## A positive integer equal to the number of observations minus the number
    ## of estimated coefficients: @code{DFE = NumObservations -
    ## NumEstimatedCoefficients}.  This property is read-only.
    ##
    ## @end deftp
    DFE = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} LogLikelihood
    ##
    ## Log-likelihood of the fitted model
    ##
    ## A scalar numeric value equal to the log-likelihood of the response
    ## values, assuming each response is normally distributed with mean equal
    ## to the fitted value and variance equal to @math{SSE/n} (the MLE
    ## variance estimate).  This property is read-only.
    ##
    ## @end deftp
    LogLikelihood = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} ModelCriterion
    ##
    ## Model comparison criteria
    ##
    ## A structure with four fields:
    ## @itemize
    ## @item @code{AIC} - Akaike information criterion:
    ##   @math{-2 * logL + 2 * m}
    ## @item @code{AICc} - AIC corrected for sample size:
    ##   @math{AIC + (2*m*(m+1))/(n-m-1)}
    ## @item @code{BIC} - Bayesian information criterion:
    ##   @math{-2 * logL + m * log(n)}
    ## @item @code{CAIC} - Consistent AIC:
    ##   @math{-2 * logL + m * (log(n) + 1)}
    ## @end itemize
    ## Here @math{logL} is @code{LogLikelihood}, @math{m} is
    ## @code{NumEstimatedCoefficients}, and @math{n} is
    ## @code{NumObservations}.  This property is read-only.
    ##
    ## @end deftp
    ModelCriterion = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} MSE
    ##
    ## Mean squared error
    ##
    ## A scalar numeric value equal to @math{SSE / DFE}, where @code{SSE} is
    ## the sum of squared errors and @code{DFE} is the degrees of freedom for
    ## error.  This property is read-only.
    ##
    ## @end deftp
    MSE = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} RMSE
    ##
    ## Root mean squared error
    ##
    ## A scalar numeric value equal to @math{sqrt(MSE)}.  This property is
    ## read-only.
    ##
    ## @end deftp
    RMSE = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} Rsquared
    ##
    ## R-squared goodness-of-fit statistics
    ##
    ## A structure with two fields:
    ## @itemize
    ## @item @code{Ordinary} - coefficient of determination:
    ##   @math{R^2 = SSR / SST}
    ## @item @code{Adjusted} - adjusted @math{R^2} that accounts for the
    ##   number of coefficients in the model
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    Rsquared = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} SSE
    ##
    ## Sum of squared errors
    ##
    ## A scalar numeric value equal to the sum of squared residuals.  For a
    ## model with an intercept, @math{SST = SSE + SSR}.  For weighted fits,
    ## this is the weighted sum of squares.  This property is read-only.
    ##
    ## @end deftp
    SSE = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} SSR
    ##
    ## Regression sum of squares
    ##
    ## A scalar numeric value equal to the sum of squared deviations of the
    ## fitted values from the mean of the response.  For a model with an
    ## intercept, @math{SST = SSE + SSR}.  For weighted fits, this is the
    ## weighted sum of squares.  This property is read-only.
    ##
    ## @end deftp
    SSR = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} SST
    ##
    ## Total sum of squares
    ##
    ## A scalar numeric value equal to the sum of squared deviations of the
    ## response from its mean. For a model with an intercept,
    ## @math{SST = SSE + SSR}. For a robust fit, @math{SST = SSE + SSR}
    ## rather than the deviation from the mean. For weighted fits, this is
    ## the weighted sum of squares. This property is read-only.
    ##
    ## @end deftp
    SST = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} Robust
    ##
    ## Robust fit information
    ##
    ## A structure with three fields:
    ## @itemize
    ## @item @code{WgtFun} - robust weighting function name, e.g.
    ##   @qcode{'bisquare'}
    ## @item @code{Tune} - tuning constant; empty if @code{WgtFun} is
    ##   @qcode{'ols'} or a function handle with the default tuning constant
    ## @item @code{Weights} - vector of final iteration weights; always
    ##   empty for a @code{CompactLinearModel} object
    ## @end itemize
    ## This structure is empty unless the model was fit using robust
    ## regression.  This property is read-only.
    ##
    ## @end deftp
    Robust = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} Formula
    ##
    ## Model formula information
    ##
    ## A structure representing the model formula with fields including
    ## @code{ResponseName}, @code{LinearPredictor}, @code{PredictorNames},
    ## @code{TermNames}, @code{HasIntercept}, @code{Terms} (the terms
    ## matrix), and @code{InModel}.  This property is read-only.
    ##
    ## @end deftp
    Formula = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} NumObservations
    ##
    ## Number of observations used in the fit
    ##
    ## A positive integer giving the number of observations actually used in
    ## fitting the original model.  Rows with missing values and rows
    ## excluded via the @code{'Exclude'} name-value argument are not counted.
    ## This property is read-only.
    ##
    ## @end deftp
    NumObservations = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} NumPredictors
    ##
    ## Number of predictor variables
    ##
    ## A positive integer giving the number of predictor variables used to
    ## fit the model.  This property is read-only.
    ##
    ## @end deftp
    NumPredictors = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} NumVariables
    ##
    ## Number of variables in the input data
    ##
    ## A positive integer giving the total number of variables in the input
    ## data used to fit the original model, counting predictors, the
    ## response, and any unused columns.  This property is read-only.
    ##
    ## @end deftp
    NumVariables = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} PredictorNames
    ##
    ## Names of predictor variables
    ##
    ## A cell array of character vectors containing the names of the
    ## predictor variables used to fit the model.  This property is
    ## read-only.
    ##
    ## @end deftp
    PredictorNames = {};

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} ResponseName
    ##
    ## Response variable name
    ##
    ## A character vector containing the name of the response variable.
    ## This property is read-only.
    ##
    ## @end deftp
    ResponseName = '';

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} VariableInfo
    ##
    ## Information about input variables
    ##
    ## A table with one row per variable including any unused variables, and
    ## four columns:
    ## @itemize
    ## @item @code{Class} - variable class as a character vector, e.g.
    ##   @qcode{'double'} or @qcode{'categorical'}
    ## @item @code{Range} - for continuous variables, a two-element vector
    ##   @code{[min, max]}; for categorical variables, a vector of the
    ##   distinct values
    ## @item @code{InModel} - logical; true if the variable is in the
    ##   fitted model
    ## @item @code{IsCategorical} - logical; true if the variable is
    ##   categorical
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    VariableInfo = [];

    ## -*- texinfo -*-
    ## @deftp {CompactLinearModel} {property} VariableNames
    ##
    ## Names of all variables in the input data
    ##
    ## A cell array of character vectors containing the names of all
    ## variables used to fit the original model, including predictors, the
    ## response, and unused variables.  This property is read-only.
    ##
    ## @end deftp
    VariableNames = {};

  endproperties

  properties(Access = private, Hidden)

    ## Terms matrix from modelspec or parse_modelspec
    TermsMatrix = [];

    ## Categorical level info for re-encoding in predict
    CatLevelInfo = [];

    ## Predictor names after categorical dummy expansion
    EncPredictorNames = {};

    ## Cached per-predictor design contrasts used by plotEffects
    EffectContrasts = [];

    ## Cached per-predictor-pair design contrasts used by plotInteraction
    InteractionContrasts = [];

    ## Whether the model includes an intercept term
    HasIntercept = true;

    ## F-statistic of the fitted model vs. the intercept-only model
    ModelFitVsNullModel = [];

  endproperties

  methods(Hidden)

    ## Custom display
    function display (this)
      in_name = inputname (1);
      if (! isempty (in_name))
        fprintf ("%s =\n", in_name);
      endif
      disp (this);
    endfunction

    ## Custom display
    function disp (this)
      if (isempty (this.Robust))
        fprintf ("\n  Compact linear regression model:\n");
      else
        fprintf ("\n  Compact linear regression model (robust fit):\n");
      endif
      if (! isempty (this.Formula) && isstruct (this.Formula) ...
          && isfield (this.Formula, 'LinearPredictor'))
        fprintf ("      %s ~ %s\n", this.ResponseName, ...
                 this.Formula.LinearPredictor);
      endif

      if (! isempty (this.Coefficients))
        fprintf ("\n  Estimated Coefficients:\n\n");
        disp (this.Coefficients);
      endif

      fprintf ("\n");
      if (! isempty (this.NumObservations) && ! isempty (this.DFE))
        fprintf ("Number of observations: %d, Error degrees of freedom: %d\n", ...
                 this.NumObservations, this.DFE);
      endif
      if (! isempty (this.RMSE))
        fprintf ("Root Mean Squared Error: %g\n", this.RMSE);
      endif
      if (! isempty (this.Rsquared) && isstruct (this.Rsquared))
        fprintf ("R-squared: %g,  Adjusted R-Squared: %g\n", ...
                 this.Rsquared.Ordinary, this.Rsquared.Adjusted);
      endif
      if (! isempty (this.ModelFitVsNullModel) ...
          && isstruct (this.ModelFitVsNullModel) ...
          && isfield (this.ModelFitVsNullModel, 'Fstat'))
        fprintf ("F-statistic vs. constant model: %g, p-value = %g\n", ...
                 this.ModelFitVsNullModel.Fstat, ...
                 this.ModelFitVsNullModel.Pvalue);
      endif
    endfunction

    ## Class specific subscripted reference
    function varargout = subsref (this, s)
      chain_s = s(2:end);
      s = s(1);
      switch (s.type)
        case '()'
          error (strcat ("CompactLinearModel: () indexing is not supported.", "  Use dot notation to access properties."));
        case '{}'
          error (strcat ("CompactLinearModel: {} indexing is not supported.", "  Use dot notation to access properties."));
        case '.'
          if (! ischar (s.subs))
            error ("CompactLinearModel.subsref: property name must be a character vector.");
          endif

          if (ismethod (this, s.subs))
            [varargout{1:nargout}] = builtin ('subsref', this, [s, chain_s]);
            return;
          endif
          try
            out = this.(s.subs);
          catch
            error ("CompactLinearModel.subsref: unknown property '%s'.", s.subs);
          end_try_catch
      endswitch
      if (! isempty (chain_s))
        out = subsref (out, chain_s);
      endif
      varargout{1} = out;
    endfunction

  endmethods

  methods(Access = public)

    function this = CompactLinearModel (mdl = [])

      if (isempty (mdl))
        return;
      elseif (! isa (mdl, 'LinearModel'))
        error ("CompactLinearModel: invalid model object.");
      endif

      this.CoefficientCovariance    = mdl.CoefficientCovariance;
      this.CoefficientNames         = mdl.CoefficientNames;
      this.Coefficients             = mdl.Coefficients;
      this.NumCoefficients          = mdl.NumCoefficients;
      this.NumEstimatedCoefficients = mdl.NumEstimatedCoefficients;

      this.DFE           = mdl.DFE;
      this.LogLikelihood = mdl.LogLikelihood;
      this.ModelCriterion = mdl.ModelCriterion;
      this.MSE           = mdl.MSE;
      this.RMSE          = mdl.RMSE;
      this.Rsquared      = mdl.Rsquared;
      this.SSE           = mdl.SSE;
      this.SSR           = mdl.SSR;
      this.SST           = mdl.SST;

      this.Robust = mdl.Robust;
      if (isstruct (this.Robust) && isfield (this.Robust, 'Weights'))
        this.Robust.Weights = [];
      endif

      this.Formula         = mdl.Formula;
      this.NumObservations = mdl.NumObservations;
      this.NumPredictors   = mdl.NumPredictors;
      this.NumVariables    = mdl.NumVariables;
      this.PredictorNames  = mdl.PredictorNames;
      this.ResponseName    = mdl.ResponseName;
      this.VariableInfo    = mdl.VariableInfo;
      this.VariableNames   = mdl.VariableNames;

      this.TermsMatrix       = mdl.TermsMatrix;
      this.CatLevelInfo      = mdl.CatLevelInfo;
      this.EncPredictorNames = mdl.EncPredictorNames;
      this.EffectContrasts   = mdl.EffectContrasts;
      this.InteractionContrasts = mdl.InteractionContrasts;
      this.HasIntercept      = mdl.HasIntercept;
      this.ModelFitVsNullModel  = mdl.ModelFitVsNullModel;

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {CompactLinearModel} {@var{ci} =} coefCI (@var{mdl})
    ## @deftypefnx {CompactLinearModel} {@var{ci} =} coefCI (@var{mdl}, @var{alpha})
    ##
    ## Confidence intervals for the coefficient estimates of a fitted linear
    ## regression model.
    ##
    ## @code{@var{ci} = coefCI (@var{mdl})} returns 95% confidence intervals
    ## for every coefficient in @var{mdl} using a default significance level of
    ## @code{0.05}.
    ##
    ## @code{@var{ci} = coefCI (@var{mdl}, @var{alpha})} uses the significance
    ## level @var{alpha}, a scalar in @math{[0, 1]}.  The resulting intervals
    ## have coverage @math{100(1-\alpha)\%}.  Setting @var{alpha} to @code{0}
    ## produces intervals of infinite width; setting it to @code{1} collapses
    ## each interval to the corresponding point estimate.
    ##
    ## The output @var{ci} is a @math{k}-by-2 numeric matrix where
    ## @math{k = } @code{@var{mdl}.NumCoefficients}.  Row @math{j} contains
    ## the interval for the @math{j}-th coefficient, whose name is stored in
    ## @code{@var{mdl}.CoefficientNames@{j@}}.  Column 1 is the lower bound and
    ## column 2 is the upper bound.  The midpoint of each interval equals the
    ## corresponding point estimate in @code{@var{mdl}.Coefficients.Estimate}.
    ##
    ## Intervals use the Wald method:
    ## @math{b_j \pm t_{(1-\alpha/2,\,\mathrm{DFE})}\,\mathrm{SE}(b_j)},
    ## where @math{b_j} is the coefficient estimate, @math{\mathrm{SE}(b_j)} is
    ## its standard error from @code{@var{mdl}.Coefficients.SE}, and the
    ## critical value is the @math{1-\alpha/2} quantile of the
    ## @math{t}-distribution with @code{@var{mdl}.DFE} degrees of freedom.
    ## In rank-deficient models, aliased coefficients have
    ## @math{\mathrm{SE} = 0} and their row in @var{ci} is @code{[0, 0]}.
    ##
    ## @end deftypefn
    function ci = coefCI (mdl, alpha)
      if (nargin > 2)
        error ("coefCI: Too many input arguments.");
      endif
      if (nargin < 2)
        alpha = 0.05;
      endif
      if (! isscalar (alpha))
        error (strcat ("coefCI: Invalid argument at position 2.", " Value must be a scalar."));
      endif
      if (! (alpha >= 0))
        error (strcat ("coefCI: Invalid argument at position 2.", " Value must be greater than or equal to 0."));
      endif
      if (alpha > 1)
        error (strcat ("coefCI: Invalid argument at position 2.", " Value must be less than or equal to 1."));
      endif

      t  = tinv (1 - alpha / 2, mdl.DFE);
      b  = mdl.Coefficients.Estimate;
      se = mdl.Coefficients.SE;
      ci = [b - t .* se, b + t .* se];

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {CompactLinearModel} {@var{p} =} coefTest (@var{mdl})
    ## @deftypefnx {CompactLinearModel} {@var{p} =} coefTest (@var{mdl}, @var{H})
    ## @deftypefnx {CompactLinearModel} {@var{p} =} coefTest (@var{mdl}, @var{H}, @var{C})
    ## @deftypefnx {CompactLinearModel} {[@var{p}, @var{F}] =} coefTest (@dots{})
    ## @deftypefnx {CompactLinearModel} {[@var{p}, @var{F}, @var{r}] =} coefTest (@dots{})
    ##
    ## Linear hypothesis test on the coefficients of a fitted linear regression
    ## model.
    ##
    ## @code{coefTest} tests whether one or more linear combinations of the
    ## fitted coefficients equal specified constants.  Each linear combination
    ## is encoded as a row of the contrast matrix @var{H}, and the right-hand
    ## side is given by @var{C}.
    ##
    ## @code{@var{p} = coefTest (@var{mdl})} performs the overall model F-test:
    ## it tests the joint null hypothesis that every coefficient except the
    ## intercept is zero.  The returned p-value matches the F-statistic line
    ## printed at the bottom of the model display.
    ##
    ## @code{@var{p} = coefTest (@var{mdl}, @var{H})} tests the null hypothesis
    ## @math{H \beta = 0}, where @math{\beta} is the full coefficient vector
    ## of length @math{k = } @code{@var{mdl}.NumCoefficients}.  @var{H} must be
    ## a full-rank numeric matrix with @math{k} columns; each row specifies one
    ## linear constraint.  To test a single coefficient, use a row vector with a
    ## @code{1} in that coefficient's position and zeros elsewhere; the
    ## resulting F-statistic equals the square of the corresponding t-statistic
    ## in @code{@var{mdl}.Coefficients}.  To test a categorical predictor that
    ## expands to multiple indicator columns, include one row per indicator in
    ## @var{H}.
    ##
    ## @code{@var{p} = coefTest (@var{mdl}, @var{H}, @var{C})} tests
    ## @math{H \beta = C} instead of zero.  @var{C} must be a numeric vector
    ## with the same number of elements as rows of @var{H}; both row and column
    ## vectors are accepted.
    ##
    ## The second output @var{F} is the value of the F-statistic:
    ## @math{F = (H\hat{\beta} - C)^\prime (H V H^\prime)^{-1}
    ## (H\hat{\beta} - C) / r}, where @math{V} is
    ## @code{@var{mdl}.CoefficientCovariance} and @math{r} is the number of
    ## rows of @var{H}.  The third output @var{r} is that numerator degrees of
    ## freedom; the denominator degrees of freedom is @code{@var{mdl}.DFE}.
    ## Under the null hypothesis @math{F} follows an @math{F(r, \mathrm{DFE})}
    ## distribution and the p-value is the upper-tail probability.  When
    ## @var{H} is rank-deficient but contains no @code{NaN}, both @var{p} and
    ## @var{F} are returned as @code{NaN} without an error.
    ##
    ## @end deftypefn
    function [p, F, r] = coefTest (mdl, varargin)
      if (nargout > 3)
        error ("coefTest: Too many output arguments.");
      endif
      if (numel (varargin) > 2)
        error ("coefTest: Too many input arguments.");
      endif

      k = mdl.NumCoefficients;

      if (numel (varargin) >= 1 && ! isempty (varargin{1}))

        H = varargin{1};
        if (! isnumeric (H))
          error ("coefTest: H must be a %d-by-%d numeric matrix.", size (H, 1), k);
        endif
        if (size (H, 2) != k)
          error ("coefTest: H must be a %d-by-%d numeric matrix.", size (H, 1), k);
        endif
        if (any (any (isnan (H))))
          error (strcat ("coefTest: H is not full rank and hypotheses", " are not consistent."));
        endif
        r = size (H, 1);

        if (numel (varargin) == 2)
          C = varargin{2};
          if (! isnumeric (C))
            error ("coefTest: C must be a numeric vector.");
          endif
          C = C(:);
          if (numel (C) != r)
            error ("coefTest: H must be a %d-by-%d numeric matrix.", numel (C), k);
          endif
        else
          C = zeros (r, 1);
        endif

      else

        if (mdl.HasIntercept && k > 1)
          H = [zeros(k-1, 1), eye(k-1)];
          r = k - 1;
        else
          H = eye (k);
          r = k;
        endif
        C = zeros (r, 1);

      endif

      b    = mdl.Coefficients.Estimate;
      V    = mdl.CoefficientCovariance;
      HVH  = H * V * H';
      Hb_c = H * b - C;
      if (rcond (HVH) < eps (class (HVH)))
        F = NaN;
        p = NaN;
      else
        F = (Hb_c' * (HVH \ Hb_c)) / r;
        p = betainc (mdl.DFE / (mdl.DFE + r * F), mdl.DFE / 2, r / 2);
      endif

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {CompactLinearModel} {@var{ypred} =} predict (@var{mdl}, @var{Xnew})
    ## @deftypefnx {CompactLinearModel} {[@var{ypred}, @var{yci}] =} predict (@var{mdl}, @var{Xnew})
    ## @deftypefnx {CompactLinearModel} {[@var{ypred}, @var{yci}] =} predict (@var{mdl}, @var{Xnew}, @var{Name}, @var{Value})
    ##
    ## Predict responses from a fitted linear regression model.
    ##
    ## @code{@var{ypred} = predict (@var{mdl}, @var{Xnew})} returns the fitted
    ## response values at the new predictor locations in @var{Xnew}.  @var{Xnew}
    ## can be a numeric matrix with one column per predictor in the same order
    ## as the training data, or a table whose column names match
    ## @code{@var{mdl}.PredictorNames}.  Rows containing @code{NaN} are returned
    ## as @code{NaN} without error.  Unlike @code{LinearModel}, @var{Xnew} is
    ## required: a @code{CompactLinearModel} object does not store the
    ## training data, so there is no default to fall back on when it is
    ## omitted.
    ##
    ## @code{[@var{ypred}, @var{yci}] = predict (@dots{})} also returns
    ## @var{yci}, an @math{n}-by-2 matrix of confidence bounds where column 1 is
    ## the lower bound and column 2 is the upper bound.  By default these are
    ## 95% pointwise confidence intervals on the mean response.
    ##
    ## Name-Value pair arguments:
    ##
    ## @multitable @columnfractions 0.2 0.78
    ## @headitem @var{Name} @tab @var{Value}
    ##
    ## @item @qcode{'Alpha'} @tab Significance level for the confidence
    ## interval, specified as a scalar in @math{[0,1]}.  The interval has
    ## coverage @math{100(1-\alpha)\%}.  Default is @code{0.05}, giving a 95%
    ## interval.
    ##
    ## @item @qcode{'Prediction'} @tab Type of interval to compute.
    ## @code{"curve"} (default) gives a confidence interval on the mean response
    ## @math{f(x)}.  @code{"observation"} gives a wider prediction interval for
    ## a single future observation @math{y = f(x) + \varepsilon}, which accounts
    ## for both estimation uncertainty and irreducible noise; it adds
    ## @code{@var{mdl}.MSE} to the variance before computing the half-width.
    ##
    ## @item @qcode{'Simultaneous'} @tab Logical flag controlling whether
    ## the bounds are simultaneous or pointwise.  When @code{true},
    ## Scheff@'{e}'s method is used so the entire predicted curve lies within
    ## the band with @math{100(1-\alpha)\%} confidence; these bands are always
    ## wider than pointwise ones.  Default is @code{false}.
    ## @end multitable
    ##
    ## @end deftypefn
    function [ypred, yci] = predict (mdl, Xnew, varargin)
      if (nargin < 2)
        error ("predict: Not enough input arguments.");
      endif

      alpha    = 0.05;
      pred_obs = false;
      simultan = false;

      i = 1;
      while (i <= numel (varargin))
        if (strcmpi (varargin{i}, 'Alpha'))
          alpha = varargin{i+1};
          if (! isscalar (alpha) || ! isnumeric (alpha) || alpha < 0 || alpha > 1)
            error ("predict: Alpha must be a scalar in [0,1].");
          endif
          i += 2;
        elseif (strcmpi (varargin{i}, 'Prediction'))
          pred_str = lower (char (varargin{i+1}));
          if (! any (strcmp (pred_str, {'curve', 'observation'})))
            error ("predict: Prediction must be 'curve' or 'observation'.");
          endif
          pred_obs = strcmp (pred_str, 'observation');
          i += 2;
        elseif (strcmpi (varargin{i}, 'Simultaneous'))
          simultan = logical (varargin{i+1});
          i += 2;
        else
          error ("predict: unknown option '%s'.", varargin{i});
        endif
      endwhile

      pred_names = mdl.PredictorNames;
      p_raw      = mdl.NumPredictors;

      if (istable (Xnew))
        n_new = height (Xnew);
        X_raw = zeros (n_new, p_raw);
        for j = 1:p_raw
          if (! ismember (pred_names{j}, Xnew.Properties.VariableNames))
            error ("predict: Xnew table is missing predictor '%s'.", pred_names{j});
          endif
          col = Xnew.(pred_names{j});
          if (iscell (col))
            cat_idx = [];
            if (! isempty (mdl.CatLevelInfo.names))
              cat_idx = find (strcmp (mdl.CatLevelInfo.names, pred_names{j}));
            endif
            if (! isempty (cat_idx))
              levels_j = mdl.CatLevelInfo.levels{cat_idx};
              codes    = zeros (n_new, 1);
              for k = 1:numel (levels_j)
                codes(strcmp (col, levels_j{k})) = k;
              endfor
              X_raw(:, j) = codes;
            endif
          else
            X_raw(:, j) = double (col);
          endif
        endfor
      else
        X_raw = double (Xnew);
        if (columns (X_raw) != p_raw)
          error ("predict: Xnew must have %d columns.", p_raw);
        endif
        n_new = rows (X_raw);
      endif

      nan_rows     = any (isnan (X_raw), 2);
      X_enc_new    = reencode_predictors (X_raw, pred_names, mdl.CatLevelInfo, mdl.EncPredictorNames);
      X_design_new = build_design (mdl.TermsMatrix, X_enc_new);

      beta            = mdl.Coefficients.Estimate;
      ypred           = X_design_new * beta;
      ypred(nan_rows) = NaN;

      if (nargout > 1)
        CovB   = mdl.CoefficientCovariance;
        var_cv = sum ((X_design_new * CovB) .* X_design_new, 2);
        if (pred_obs)
          var_ci = var_cv + mdl.MSE;
        else
          var_ci = var_cv;
        endif
        p_est = mdl.NumEstimatedCoefficients;
        if (simultan)
          mult = sqrt (p_est * finv (1 - alpha, p_est, mdl.DFE));
        else
          mult = tinv (1 - alpha / 2, mdl.DFE);
        endif
        hw              = mult * sqrt (max (var_ci, 0));
        yci             = [ypred - hw, ypred + hw];
        yci(nan_rows,:) = NaN;
      endif

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn {CompactLinearModel} {@var{ysim} =} random (@var{mdl}, @var{Xnew})
    ##
    ## Simulate responses with random noise from a fitted linear regression
    ## model.
    ##
    ## @code{@var{ysim} = random (@var{mdl}, @var{Xnew})} computes the fitted
    ## response at each row of @var{Xnew} and then adds independent Gaussian
    ## noise to each value.  The noise is drawn from @math{N(0, \sigma^2)} where
    ## @math{\sigma^2} is the estimated error variance @code{@var{mdl}.MSE}
    ## (mean squared error of the fit).  The result is a column vector of the
    ## same length as the number of rows in @var{Xnew}.
    ##
    ## @var{Xnew} is required and must be non-empty.  It can be a numeric
    ## matrix with one column per predictor in the same order as the training
    ## data, or a table whose column names match
    ## @code{@var{mdl}.PredictorNames}.
    ##
    ## Because the added noise is drawn freshly on every call, two calls with
    ## the same @var{Xnew} will generally produce different output.  To get
    ## reproducible results, set the random seed with @code{rand ('state', s)}
    ## before calling @code{random}.
    ##
    ## For deterministic predictions without noise, use @code{predict} or
    ## @code{feval}.  @code{predict} also provides confidence intervals on the
    ## mean response.
    ##
    ## @end deftypefn
    function ysim = random (mdl, Xnew, varargin)
      if (nargin < 2)
        error ("random: Not enough input arguments.");
      endif
      if (nargin > 2)
        error ("random: Too many input arguments.");
      endif
      if (isempty (Xnew))
        error ("random: Xnew must have %d columns.", mdl.NumPredictors);
      endif
      ypred = predict (mdl, Xnew);
      ysim  = ypred + sqrt (mdl.MSE) .* randn (numel (ypred), 1);
    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {CompactLinearModel} {@var{ypred} =} feval (@var{mdl}, @var{X})
    ## @deftypefnx {CompactLinearModel} {@var{ypred} =} feval (@var{mdl}, @var{x1}, @var{x2}, @dots{}, @var{xp})
    ##
    ## Predict responses of a fitted linear regression model using separate
    ## predictor inputs.
    ##
    ## @code{@var{ypred} = feval (@var{mdl}, @var{X})} accepts a single
    ## numeric matrix @var{X} with one column per predictor in the same order
    ## as the training data, or a table whose column names match
    ## @code{@var{mdl}.PredictorNames}.  The output is an @math{n}-by-1 column
    ## vector.  Rows that contain @code{NaN} in any predictor column are
    ## returned as @code{NaN}.
    ##
    ## @code{@var{ypred} = feval (@var{mdl}, @var{x1}, @var{x2}, @dots{},
    ## @var{xp})} accepts exactly @code{@var{mdl}.NumPredictors} separate
    ## arguments, one per predictor variable.  All non-scalar arguments must
    ## have the same size; a scalar argument is broadcast to that size
    ## automatically.  The output shape follows the shape of the non-scalar
    ## inputs: column vector inputs give a column vector output, row vector
    ## inputs give a row vector output, and all-scalar inputs give a scalar.
    ## This form is convenient when predictor data is already stored in separate
    ## vectors rather than a combined matrix.
    ##
    ## @code{feval} gives the same numerical predictions as @code{predict} but
    ## does not support confidence intervals.  Use @code{predict} when you also
    ## need bounds on the response.  Because a @code{CompactLinearModel} object
    ## behaves like a function through @code{feval}, it can be passed directly
    ## to routines that accept a function handle, such as @code{fminsearch} or
    ## @code{integral}.
    ##
    ## @end deftypefn
    function ypred = feval (mdl, varargin)
      p_raw   = mdl.NumPredictors;
      n_extra = nargin - 1;

      if (n_extra < 1)
        error ("feval: Not enough input arguments.");
      endif

      if (n_extra == 1)

        Xnew = varargin{1};

        if (istable (Xnew))
          for j = 1:p_raw
            if (! ismember (mdl.PredictorNames{j}, Xnew.Properties.VariableNames))
              error (strcat ("feval: X does not contain one or more predictor", " variables needed for this model."));
            endif
          endfor
        else
          if (columns (double (Xnew)) != p_raw)
            error ("feval: Predictor data matrix must have %d columns.", p_raw);
          endif
        endif

        ypred = predict (mdl, Xnew);

      elseif (n_extra == p_raw)

        for i = 1:n_extra
          if (ischar (varargin{i}) || iscategorical (varargin{i}))
            if (iscategorical (varargin{i}))
              lvl_str = char (varargin{i});
            else
              lvl_str = varargin{i};
            endif
            ci = [];
            if (! isempty (mdl.CatLevelInfo.names))
              ci = find (strcmp (mdl.CatLevelInfo.names, mdl.PredictorNames{i}));
            endif
            if (isempty (ci))
              error ("feval: predictor '%s' is not categorical.", mdl.PredictorNames{i});
            endif
            levels_i = mdl.CatLevelInfo.levels{ci};
            code     = find (strcmp (levels_i, lvl_str), 1);
            if (isempty (code))
              code = NaN;
            endif
            varargin{i} = code;
          endif
        endfor

        ref_size = [];
        for i = 1:n_extra
          if (! isscalar (varargin{i}))
            s_i = size (varargin{i});
            if (isempty (ref_size))
              ref_size = s_i;
            elseif (! isequal (s_i, ref_size))
              error ("feval: All input arguments must be the same size.");
            endif
          endif
        endfor
        if (isempty (ref_size))
          ref_size = [1, 1];
        endif

        n_pts = prod (ref_size);
        Xmat  = zeros (n_pts, p_raw);
        for i = 1:n_extra
          ai = varargin{i};
          if (isscalar (ai))
            Xmat(:, i) = ai;
          else
            Xmat(:, i) = ai(:);
          endif
        endfor

        ypred = reshape (predict (mdl, Xmat), ref_size);

      else

        error (strcat ("feval: Incorrect number of input arguments. You must provide", " either %d separate predictor variable arguments, or one", " predictor matrix with %d columns."), p_raw, p_raw);

      endif

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {CompactLinearModel} {} plotEffects (@var{mdl})
    ## @deftypefnx {CompactLinearModel} {} plotEffects (@var{ax}, @var{mdl})
    ## @deftypefnx {CompactLinearModel} {@var{h} =} plotEffects (@dots{})
    ##
    ## Plot the main effects of each predictor in a compact linear regression
    ## model.
    ##
    ## @code{plotEffects (@var{mdl})} creates a horizontal dot-and-line plot
    ## with one row per predictor.  Each dot shows the estimated main effect on
    ## the response from changing that predictor from its minimum observed value
    ## to its maximum observed value, while holding all other predictors fixed
    ## at their observed means.  A horizontal line through each dot shows the
    ## 95% confidence interval for that effect.
    ##
    ## The main effect for predictor @var{xs} is defined as
    ## @math{g(x_{s,\max}) - g(x_{s,\min})}, where the adjusted response
    ## function @math{g} evaluates the model at the specified value of
    ## @var{xs} with all other predictors set to their observed means.
    ## For numeric predictors the sign of the effect can be positive or
    ## negative depending on the direction of the relationship.  Because a
    ## @code{CompactLinearModel} does not retain the training data, these
    ## values come from a summary computed once when the model was fitted,
    ## rather than recomputed from the original observations.
    ##
    ## @code{plotEffects (@var{ax}, @var{mdl})} creates the plot in the axes
    ## object @var{ax} instead of the current axes returned by @code{gca}.
    ##
    ## @code{@var{h} = plotEffects (@dots{})} returns a vector of
    ## @math{p+1} graphics handles where @math{p} is the number of predictors.
    ## @code{h(1)} is the line object containing the effect estimate markers
    ## (one circle per predictor, plotted as a single line object with
    ## @code{XData} of length @math{p} and @code{YData = 1:p}).
    ## @code{h(j+1)} is the confidence interval line for predictor @math{j},
    ## with @code{XData = [ci_lo, ci_hi]} and @code{YData = [j, j]}.
    ##
    ## The y-axis tick labels follow the format
    ## @qcode{'varname: min to max'}, showing the predictor name and the
    ## minimum and maximum observed values used to compute the effect.
    ##
    ## @end deftypefn
    function h = plotEffects (this, varargin)
      [ax, mdl, args] = cm_plot_axes (this, varargin);

      if (! isempty (args))
        error ("plotEffects: Wrong number of arguments.");
      endif

      p = mdl.NumPredictors;
      if (! any (any (mdl.TermsMatrix(:, 1:end-1) != 0)))
        error ("plotEffects: Model has no predictors.");
      endif

      if (isempty (ax))
        ax = gca ();
      endif

      DEF_COLOR = [0.1490, 0.5490, 0.8660];

      pred   = mdl.PredictorNames;
      V      = mdl.CoefficientCovariance;
      beta   = mdl.Coefficients.Estimate;
      t_crit = tinv (0.975, mdl.DFE);
      cinfo  = mdl.CatLevelInfo;
      C      = mdl.EffectContrasts;

      effects = zeros (1, p);
      ci_lo   = zeros (1, p);
      ci_hi   = zeros (1, p);

      for j = 1:p
        effects(j) = C(j,:) * beta;
        SE         = sqrt (max (0, C(j,:) * V * C(j,:)'));

        ci_lo(j) = effects(j) - t_crit * SE;
        ci_hi(j) = effects(j) + t_crit * SE;
      endfor

      hold (ax, 'on');
      h(1) = plot (ax, effects, 1:p, ...
                   'LineStyle', 'none', ...
                   'Marker', 'o', ...
                   'MarkerSize', 6, ...
                   'Color', DEF_COLOR);
      for j = 1:p
        h(j+1) = line ([ci_lo(j), ci_hi(j)], [j, j], ...
                        'LineStyle', '-', ...
                        'Marker', 'none', ...
                        'Color', DEF_COLOR, ...
                        'Parent', ax);
      endfor
      hold (ax, 'off');

      rn  = mdl.VariableInfo.Properties.RowNames;
      ytl = cell (p, 1);
      for j = 1:p
        ci = [];
        if (! isempty (cinfo) && isfield (cinfo, 'names') && ! isempty (cinfo.names))
          ci = find (strcmp (cinfo.names, pred{j}));
        endif

        vidx = find (strcmp (rn, pred{j}));
        rng  = mdl.VariableInfo.Range{vidx};

        if (! isempty (ci))
          levels_j = cinfo.levels{ci};
          lo_str = char (levels_j{1});
          hi_str = char (levels_j{end});
        else
          lo_str = num2str (rng(1), '%g');
          hi_str = num2str (rng(2), '%g');
        endif
        ytl{j} = [pred{j}, ': ', lo_str, ' to ', hi_str];
      endfor

      set (ax, 'YTick', 1:p, 'YTickLabel', ytl, 'YDir', 'reverse');
      ylim  (ax, [0.5, p + 0.5]);
      xlabel (ax, 'Main Effect');
      ylabel (ax, '');
      title (ax, 'Main Effects Plot');

      if (nargout == 0)
        clear h;
      endif

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {CompactLinearModel} {} plotInteraction (@var{mdl}, @var{var1}, @var{var2})
    ## @deftypefnx {CompactLinearModel} {} plotInteraction (@var{mdl}, @var{var1}, @var{var2}, @var{ptype})
    ## @deftypefnx {CompactLinearModel} {} plotInteraction (@var{ax}, @dots{})
    ## @deftypefnx {CompactLinearModel} {@var{h} =} plotInteraction (@dots{})
    ##
    ## Plot the interaction effects of two predictors in a compact linear
    ## regression model.
    ##
    ## @code{plotInteraction (@var{mdl}, @var{var1}, @var{var2})} creates a
    ## plot of the main effects of @var{var1} and @var{var2} together with
    ## their conditional effects, with horizontal lines through each effect
    ## value indicating its 95% confidence interval.  @var{var1} and
    ## @var{var2} are each a character vector or string naming a variable in
    ## @code{mdl.VariableNames}, or a positive integer indexing into
    ## @code{mdl.VariableNames}; neither may name the response variable, and
    ## they must be different variables.
    ##
    ## The main effect of a predictor is the change in the adjusted response
    ## between the two predictor values that produce the minimum and maximum
    ## adjusted response, with the other predictor averaged over its own
    ## observed values row by row.  For a numeric predictor these two values
    ## are its observed minimum and maximum; for a categorical predictor
    ## every level is evaluated and the levels producing the minimum and
    ## maximum adjusted response are used, so the effect is always
    ## nonnegative.
    ##
    ## The conditional effect of @var{var1} is its effect recomputed with
    ## @var{var2} additionally held fixed at each of a small set of
    ## conditioning values, and likewise the conditional effect of
    ## @var{var2} holds @var{var1} fixed.  The conditioning values are the
    ## observed minimum, mean of the minimum and maximum, and maximum for a
    ## numeric predictor, or every level for a categorical predictor.  When
    ## the main effect and conditional effect points for a predictor do not
    ## align vertically, the model exhibits an interaction between
    ## @var{var1} and @var{var2}.  Because a @code{CompactLinearModel} does
    ## not retain the training data, these values come from a summary
    ## computed once when the model was fitted, rather than recomputed from
    ## the original observations.
    ##
    ## @code{plotInteraction (@var{mdl}, @var{var1}, @var{var2}, @var{ptype})}
    ## selects the plot type.  @var{ptype} is @qcode{'effects'} (default), as
    ## described above, or @qcode{'predictions'}, which instead plots the
    ## adjusted response as a function of @var{var2} for each conditioning
    ## value of @var{var1} held fixed, evaluated over 101 equally spaced
    ## points spanning the observed range of @var{var2} when @var{var2} is
    ## numeric, or at each level of @var{var2} when it is categorical.
    ##
    ## @code{plotInteraction (@var{ax}, @dots{})} plots into the axes object
    ## @var{ax} instead of the current axes returned by @code{gca}.
    ##
    ## @code{@var{h} = plotInteraction (@dots{})} returns a vector of line
    ## handles.  When @var{ptype} is @qcode{'effects'}, @code{h(1)} is the
    ## marker line through the two main effect points, @code{h(2)} and
    ## @code{h(3)} are the confidence interval lines for the main effects of
    ## @var{var1} and @var{var2}, and the remaining entries are the
    ## conditional effect points and their confidence intervals, tagged
    ## @qcode{'conditional1'} for @var{var1} and @qcode{'conditional2'} for
    ## @var{var2}.  The main effect line objects are tagged @qcode{'main'}.
    ## When @var{ptype} is @qcode{'predictions'}, each entry in @var{h}
    ## corresponds to one adjusted response curve, one per conditioning
    ## value of @var{var1}.
    ##
    ## @end deftypefn
    function h = plotInteraction (this, varargin)
      [ax, mdl, args] = cm_plot_axes (this, varargin);

      if (numel (args) < 2)
        error ("plotInteraction: Not enough input arguments.");
      endif

      var1 = args{1};
      var2 = args{2};
      args = args(3:end);

      ptype = 'effects';
      if (! isempty (args) && (ischar (args{1}) || isstring (args{1})))
        ptype = lower (char (args{1}));
        args  = args(2:end);
        if (! any (strcmp (ptype, {'effects', 'predictions'})))
          error ("plotInteraction: PTYPE must be 'effects' or 'predictions'.");
        endif
      endif
      if (! isempty (args))
        error ("plotInteraction: Too many input arguments.");
      endif

      vnames = mdl.VariableNames;

      if (ischar (var1) || isstring (var1))
        v1name = char (var1);
        if (isempty (find (strcmp (vnames, v1name))))
          error ("plotInteraction: '%s' is not a variable for this fit.", v1name);
        endif
      elseif (isnumeric (var1) && isscalar (var1))
        if (var1 != fix (var1) || var1 < 1)
          error (strcat ("plotInteraction: Variable must be specified as a", " name or a positive integer."));
        endif
        if (var1 > numel (vnames))
          error ("plotInteraction: This model only contains %d variables.", numel (vnames));
        endif
        v1name = vnames{var1};
      else
        error (strcat ("plotInteraction: Variable must be specified as a", " name or a positive integer."));
      endif
      if (strcmp (v1name, mdl.ResponseName))
        error ("plotInteraction: The variable '%s' is the response in this model.", v1name);
      endif

      if (ischar (var2) || isstring (var2))
        v2name = char (var2);
        if (isempty (find (strcmp (vnames, v2name))))
          error ("plotInteraction: '%s' is not a variable for this fit.", v2name);
        endif
      elseif (isnumeric (var2) && isscalar (var2))
        if (var2 != fix (var2) || var2 < 1)
          error (strcat ("plotInteraction: Variable must be specified as a", " name or a positive integer."));
        endif
        if (var2 > numel (vnames))
          error ("plotInteraction: This model only contains %d variables.", numel (vnames));
        endif
        v2name = vnames{var2};
      else
        error (strcat ("plotInteraction: Variable must be specified as a", " name or a positive integer."));
      endif
      if (strcmp (v2name, mdl.ResponseName))
        error ("plotInteraction: The variable '%s' is the response in this model.", v2name);
      endif

      if (strcmp (v1name, v2name))
        error ("plotInteraction: VAR1 and VAR2 must be different variables.");
      endif

      pred   = mdl.PredictorNames;
      cinfo  = mdl.CatLevelInfo;
      beta   = mdl.Coefficients.Estimate;
      V      = mdl.CoefficientCovariance;
      t_crit = tinv (0.975, mdl.DFE);
      C      = mdl.EffectContrasts;
      IC     = mdl.InteractionContrasts;
      rn     = mdl.VariableInfo.Properties.RowNames;

      j1 = find (strcmp (pred, v1name));
      j2 = find (strcmp (pred, v2name));

      is_cat1 = ! isempty (cinfo) && isfield (cinfo, 'names') ...
                && any (strcmp (cinfo.names, v1name));
      is_cat2 = ! isempty (cinfo) && isfield (cinfo, 'names') ...
                && any (strcmp (cinfo.names, v2name));

      if (is_cat1)
        ci1      = find (strcmp (cinfo.names, v1name));
        levels_1 = cinfo.levels{ci1};
        n_lv1    = numel (levels_1);
        g_lv1    = IC.OwnGridRows{j1} * beta;
        [~, i_lo1] = min (g_lv1);
        [~, i_hi1] = max (g_lv1);
        lbl1 = [v1name, ': ', char(levels_1{i_lo1}), ' to ', char(levels_1{i_hi1})];
        grid1 = (1:n_lv1)';
        grid1_lbls = cellfun (@(s) char (s), levels_1, 'UniformOutput', false);
        eff1 = g_lv1(i_hi1) - g_lv1(i_lo1);
        c_diff1 = IC.OwnGridRows{j1}(i_hi1,:) - IC.OwnGridRows{j1}(i_lo1,:);
        se1  = sqrt (max (0, c_diff1 * V * c_diff1'));
        hi1v = i_hi1;  lo1v = i_lo1;
      else
        vidx1 = find (strcmp (rn, v1name));
        rng1  = mdl.VariableInfo.Range{vidx1};
        lo1 = rng1(1);  hi1 = rng1(2);
        lbl1 = [v1name, ': ', num2str(lo1), ' to ', num2str(hi1)];
        grid1 = [lo1; (lo1+hi1)/2; hi1];
        grid1_lbls = arrayfun (@(v) num2str(v,'%g'), grid1, 'UniformOutput', false);
        eff1 = C(j1,:) * beta;
        se1  = sqrt (max (0, C(j1,:) * V * C(j1,:)'));
        hi1v = hi1;  lo1v = lo1;
      endif

      if (is_cat2)
        ci2      = find (strcmp (cinfo.names, v2name));
        levels_2 = cinfo.levels{ci2};
        n_lv2    = numel (levels_2);
        g_lv2    = IC.OwnGridRows{j2} * beta;
        [~, i_lo2] = min (g_lv2);
        [~, i_hi2] = max (g_lv2);
        lbl2 = [v2name, ': ', char(levels_2{i_lo2}), ' to ', char(levels_2{i_hi2})];
        grid2 = (1:n_lv2)';
        grid2_lbls = cellfun (@(s) char (s), levels_2, 'UniformOutput', false);
        eff2 = g_lv2(i_hi2) - g_lv2(i_lo2);
        c_diff2 = IC.OwnGridRows{j2}(i_hi2,:) - IC.OwnGridRows{j2}(i_lo2,:);
        se2  = sqrt (max (0, c_diff2 * V * c_diff2'));
        hi2v = i_hi2;  lo2v = i_lo2;
      else
        vidx2 = find (strcmp (rn, v2name));
        rng2  = mdl.VariableInfo.Range{vidx2};
        lo2 = rng2(1);  hi2 = rng2(2);
        lbl2 = [v2name, ': ', num2str(lo2), ' to ', num2str(hi2)];
        grid2 = [lo2; (lo2+hi2)/2; hi2];
        grid2_lbls = arrayfun (@(v) num2str(v,'%g'), grid2, 'UniformOutput', false);
        eff2 = C(j2,:) * beta;
        se2  = sqrt (max (0, C(j2,:) * V * C(j2,:)'));
        hi2v = hi2;  lo2v = lo2;
      endif

      P12 = IC.Pairs{j1,j2};
      n2  = numel (grid2);
      if (isempty (P12))
        eff_c1 = repmat (eff1, n2, 1);
        se_c1  = repmat (se1, n2, 1);
      else
        n2c = numel (P12.grid2);
        eff_c1 = zeros (n2, 1);
        se_c1  = zeros (n2, 1);
        for k = 1:n2
          idx1_hi = find (P12.grid1 == hi1v, 1);
          idx1_lo = find (P12.grid1 == lo1v, 1);
          idx2_k  = find (P12.grid2 == grid2(k), 1);
          c_hi = P12.rows((idx1_hi-1)*n2c + idx2_k, :);
          c_lo = P12.rows((idx1_lo-1)*n2c + idx2_k, :);
          eff_c1(k) = (c_hi - c_lo) * beta;
          se_c1(k)  = sqrt (max (0, (c_hi - c_lo) * V * (c_hi - c_lo)'));
        endfor
      endif

      P21 = IC.Pairs{j2,j1};
      n1  = numel (grid1);
      if (isempty (P21))
        eff_c2 = repmat (eff2, n1, 1);
        se_c2  = repmat (se2, n1, 1);
      else
        n2c = numel (P21.grid2);
        eff_c2 = zeros (n1, 1);
        se_c2  = zeros (n1, 1);
        for k = 1:n1
          idx1_hi = find (P21.grid1 == hi2v, 1);
          idx1_lo = find (P21.grid1 == lo2v, 1);
          idx2_k  = find (P21.grid2 == grid1(k), 1);
          c_hi = P21.rows((idx1_hi-1)*n2c + idx2_k, :);
          c_lo = P21.rows((idx1_lo-1)*n2c + idx2_k, :);
          eff_c2(k) = (c_hi - c_lo) * beta;
          se_c2(k)  = sqrt (max (0, (c_hi - c_lo) * V * (c_hi - c_lo)'));
        endfor
      endif

      if (isempty (ax))
        ax = gca ();
      endif
      cla (ax);

      DEF_COLOR = [0.1490, 0.5490, 0.8660];
      FIT_COLOR = [0.9600, 0.4660, 0.1600];

      if (strcmp (ptype, 'effects'))

        y_main1 = 1;
        y_cond1 = (2:(1+n2))';
        y_main2 = n2 + 4;
        y_cond2 = ((n2+5):(n2+4+n1))';

        hold (ax, 'on');
        line ([0, 0], [0.5, n2 + n1 + 4.5], 'LineStyle', ':', 'Marker', 'none', ...
              'Color', [0, 0, 0], 'Parent', ax);

        h(1) = plot (ax, [eff1, eff2], [y_main1, y_main2], ...
                     'LineStyle', 'none', 'Marker', 'o', 'Color', DEF_COLOR, ...
                     'Tag', 'main');
        h(2) = line ([eff1 - t_crit*se1, eff1 + t_crit*se1], [y_main1, y_main1], ...
                     'LineStyle', '-', 'Marker', 'none', 'Color', DEF_COLOR, ...
                     'Parent', ax, 'Tag', 'main');
        h(3) = line ([eff2 - t_crit*se2, eff2 + t_crit*se2], [y_main2, y_main2], ...
                     'LineStyle', '-', 'Marker', 'none', 'Color', DEF_COLOR, ...
                     'Parent', ax, 'Tag', 'main');
        h(4) = plot (ax, eff_c1, y_cond1, ...
                     'LineStyle', 'none', 'Marker', 'o', 'Color', FIT_COLOR, ...
                     'Tag', 'conditional1');
        for k = 1:n2
          h(4+k) = line ([eff_c1(k) - t_crit*se_c1(k), eff_c1(k) + t_crit*se_c1(k)], ...
                         [y_cond1(k), y_cond1(k)], ...
                         'LineStyle', '-', 'Marker', 'none', 'Color', FIT_COLOR, ...
                         'Parent', ax, 'Tag', 'conditional1');
        endfor
        h(5+n2) = plot (ax, eff_c2, y_cond2, ...
                        'LineStyle', 'none', 'Marker', 'o', 'Color', FIT_COLOR, ...
                        'Tag', 'conditional2');
        for k = 1:n1
          h(5+n2+k) = line ([eff_c2(k) - t_crit*se_c2(k), eff_c2(k) + t_crit*se_c2(k)], ...
                            [y_cond2(k), y_cond2(k)], ...
                            'LineStyle', '-', 'Marker', 'none', 'Color', FIT_COLOR, ...
                            'Parent', ax, 'Tag', 'conditional2');
        endfor
        hold (ax, 'off');

        ytl = cell (2 + n1 + n2, 1);
        ytl{1} = lbl1;
        for k = 1:n2
          ytl{1+k} = [v2name, '=', grid2_lbls{k}];
        endfor
        ytl{2+n2} = lbl2;
        for k = 1:n1
          ytl{2+n2+k} = [v1name, '=', grid1_lbls{k}];
        endfor

        set (ax, 'YTick', [y_main1; y_cond1; y_main2; y_cond2], ...
                 'YTickLabel', ytl, 'YDir', 'reverse');
        ylim  (ax, [0.5, n2 + n1 + 4.5]);
        xlabel (ax, 'Effect');
        ylabel (ax, '');
        title  (ax, ['Interaction of ', v1name, ' and ', v2name]);

      else ## 'predictions'

        if (is_cat2)
          x_grid2 = (1:n_lv2)';
        else
          x_grid2 = linspace (lo2, hi2, 101)';
        endif

        hold (ax, 'on');
        line (NaN, NaN, 'Color', 'none', 'Parent', ax, 'DisplayName', v1name);

        colors   = get (ax, 'ColorOrder');
        n_colors = rows (colors);

        n2c = numel (P12.grid2);

        for k = 1:n1
          idx1_k = find (P12.grid1 == grid1(k), 1);
          row_lo = (idx1_k - 1) * n2c + 1;
          row_hi = idx1_k * n2c;
          rows_k = P12.rows(row_lo:row_hi, :);

          if (is_cat2)
            y_curve = rows_k * beta;
          else
            deg   = n2c - 1;
            Vm    = (P12.grid2(:)) .^ (0:deg);
            coefs = Vm \ rows_k;
            Vq    = (x_grid2(:)) .^ (0:deg);
            y_curve = Vq * coefs * beta;
          endif

          h(k) = line (x_grid2, y_curve, ...
                       'Color', colors(mod(k-1, n_colors)+1, :), ...
                       'LineStyle', '-', 'Marker', 'none', 'Parent', ax, ...
                       'DisplayName', grid1_lbls{k});
        endfor
        hold (ax, 'off');

        if (is_cat2)
          set (ax, 'XTick', 1:n_lv2, 'XTickLabel', grid2_lbls);
        endif

        xlabel (ax, v2name);
        ylabel (ax, ['Adjusted ', mdl.ResponseName]);
        title  (ax, ['Interaction of ', v1name, ' and ', v2name]);
        legend (ax, 'show');

      endif

      if (nargout == 0)
        clear h;
      endif

    endfunction

  endmethods

endclassdef

function [ax, mdl, args] = cm_plot_axes (this, rest)

  if (isscalar (this) && isgraphics (this, 'axes'))
    ax   = this;
    mdl  = rest{1};
    args = rest(2:end);
  else
    ax   = [];
    mdl  = this;
    args = rest;
  endif
endfunction

%!shared mdl, cmdl, X, y, n
%! n = 20;
%! X = [(1:n); (1:n).^2]' / n;
%! y = X * [3; -1] + 0.2 * sin ((1:n)');
%! mdl = fitlm (X, y);
%! cmdl = compact (mdl);

%!test
%! assert_equal (cmdl.NumObservations,          20);
%! assert_equal (cmdl.NumCoefficients,           3);
%! assert_equal (cmdl.NumVariables,              3);
%! assert_equal (cmdl.NumPredictors,             2);
%! assert_equal (cmdl.NumEstimatedCoefficients,  3);
%! assert_equal (cmdl.DFE,                      17);
%! assert_equal (cmdl.SSE,  0.386545331386823,   1e-9);
%! assert_equal (cmdl.SSR,  583.523874670959,    1e-6);
%! assert_equal (cmdl.SST,  583.910420002346,    1e-6);
%! assert_equal (cmdl.MSE,  0.0227379606698351,  1e-10);
%! assert_equal (cmdl.RMSE, 0.150791116017606,   1e-10);
%! assert_equal (cmdl.Rsquared.Ordinary, 0.999338005765704, 1e-10);
%! assert_equal (cmdl.Rsquared.Adjusted, 0.999260124091081, 1e-10);
%! assert_equal (cmdl.LogLikelihood, 11.0836133807695, 1e-6);
%! assert_equal (cmdl.ModelCriterion.AIC,  -16.1672267615389, 1e-6);
%! assert_equal (cmdl.ModelCriterion.AICc, -14.6672267615389, 1e-6);
%! assert_equal (cmdl.ModelCriterion.BIC,  -13.180029940877,  1e-6);
%! assert_equal (cmdl.ModelCriterion.CAIC, -10.180029940877,  1e-6);

%!test
%! assert_equal (cmdl.Coefficients.Estimate, [0.1161886778; 2.508451491; -0.9788353298], 1e-7);
%! assert_equal (cmdl.Coefficients.SE,       [0.112185831;  0.4920818186; 0.02276108523], 1e-8);
%! assert_equal (cmdl.Coefficients.tStat,    [1.035680502;  5.097630913; -43.00477415],   1e-6);
%! assert_equal (all (cmdl.Coefficients.pValue >= 0 & cmdl.Coefficients.pValue <= 1), true);
%! assert_equal (isequal (cmdl.CoefficientNames, {'(Intercept)', 'x1', 'x2'}), true);
%! assert_equal (isequal (cmdl.CoefficientNames, cmdl.Coefficients.Properties.RowNames(:)'), true);
%! assert_equal (size (cmdl.CoefficientCovariance), [3, 3]);
%! assert_equal (diag (cmdl.CoefficientCovariance), [0.0125857; 0.242145; 0.000518067], 1e-6);
%! assert_equal (width (cmdl.Coefficients), 4);
%! assert_equal (isequal (cmdl.Coefficients.Properties.VariableNames, ...
%!                  {'Estimate','SE','tStat','pValue'}), true);

%!test
%! assert_equal (cmdl.Formula.LinearPredictor, '1 + x1 + x2');
%! assert_equal (cmdl.Formula.HasIntercept, true);
%! assert_equal (cmdl.PredictorNames, {'x1', 'x2'});
%! assert_equal (cmdl.ResponseName, 'y');
%! assert_equal (cmdl.VariableNames, {'x1', 'x2', 'y'});
%! assert_equal (cmdl.VariableInfo.Range{1}, [0.05, 1],  1e-10);
%! assert_equal (cmdl.VariableInfo.Range{2}, [0.05, 20], 1e-10);
%! assert_equal (cmdl.VariableInfo.InModel, [true; true; false]);
%! assert_equal (cmdl.Robust, []);

%!test
%! ci = coefCI (cmdl);
%! assert_equal (size (ci), [3, 2]);
%! assert_equal (class (ci), 'double');
%! assert_equal (all (ci(:,1) < ci(:,2)), true);
%! assert_equal (ci(1,1), -0.120502736154050, 1e-10);
%! assert_equal (ci(1,2),  0.352880091734465, 1e-10);
%! assert_equal (ci(2,1),  1.470249604061007, 1e-10);
%! assert_equal (ci(2,2),  3.546653377080718, 1e-10);
%! assert_equal (ci(3,1), -1.026857022014626, 1e-10);
%! assert_equal (ci(3,2), -0.930813637635746, 1e-10);

%!test
%! ci = coefCI (cmdl);
%! t  = tinv (0.975, cmdl.DFE);
%! assert_equal ((ci(:,1) + ci(:,2)) / 2, cmdl.Coefficients.Estimate, 1e-10);
%! assert_equal (ci(:,2) - ci(:,1), 2 * t * cmdl.Coefficients.SE, 1e-10);
%! assert_equal (coefCI (cmdl, 0.05), ci);

%!test
%! ci = coefCI (cmdl, 0.01);
%! assert_equal (size (ci), [3, 2]);
%! assert_equal (ci(1,1), -0.208951721610638, 1e-10);
%! assert_equal (ci(1,2),  0.441329077191052, 1e-10);
%! assert_equal (ci(2,1),  1.082284945644892, 1e-10);
%! assert_equal (ci(2,2),  3.934618035496833, 1e-10);
%! assert_equal (ci(3,1), -1.044802201703589, 1e-10);
%! assert_equal (ci(3,2), -0.912868457946783, 1e-10);

%!test
%! ## a zero alpha gives an infinite interval and a full alpha collapses it to the estimate
%! ci = coefCI (cmdl, 0);
%! assert_equal (all (ci(:,1) == -Inf), true);
%! assert_equal (all (ci(:,2) == +Inf), true);
%! ci = coefCI (cmdl, 1);
%! assert_equal (ci(:,1), cmdl.Coefficients.Estimate, 1e-10);
%! assert_equal (ci(:,2), cmdl.Coefficients.Estimate, 1e-10);

%!test
%! m  = fitlm (X, y, 'Intercept', false);
%! cm = compact (m);
%! ci = coefCI (cm);
%! assert_equal (size (ci), [2, 2]);
%! assert_equal (ci(1,1), 2.486679110991696, 1e-10);
%! assert_equal (ci(1,2), 3.436164115360526, 1e-10);
%! assert_equal (ci(2,1), -1.027166590567854, 1e-10);
%! assert_equal (ci(2,2), -0.967330908318718, 1e-10);

%!test
%! m  = fitlm (X, y, 'Weights', (1:n)' / sum (1:n));
%! cm = compact (m);
%! ci = coefCI (cm);
%! assert_equal (size (ci), [3, 2]);
%! assert_equal (ci(1,1), -0.355978167660141, 1e-10);
%! assert_equal (ci(1,2),  0.516619434992026, 1e-10);
%! assert_equal (ci(2,1),  1.142016390035618, 1e-10);
%! assert_equal (ci(2,2),  4.154555017558383, 1e-10);
%! assert_equal (ci(3,1), -1.044530853341675, 1e-10);
%! assert_equal (ci(3,2), -0.924508441530335, 1e-10);

%!test
%! m    = fitlm ([ones(n,1), X, X(:,1)+X(:,2)], y);
%! cm   = compact (m);
%! ci   = coefCI (cm);
%! drop = find (cm.Coefficients.SE == 0);
%! keep = setdiff (1:5, drop');
%! assert_equal (size (ci), [5, 2]);
%! assert_equal (numel (drop), 2);
%! assert_equal (all (all (ci(drop, :) == 0)), true);
%! assert_equal (all (all (isfinite (ci(keep, :)))), true);
%! assert_equal ((ci(keep,1) + ci(keep,2)) / 2, cm.Coefficients.Estimate(keep), 1e-10);
%! assert_equal (cm.DFE, 17);
%! assert_equal (m.SSE, 0.386545331386824, 1e-10);
%! assert_equal (m.Rsquared.Ordinary, 0.999338005765704, 1e-10);
%! assert_equal (m.Rsquared.Adjusted, 0.999260124091081, 1e-10);

%!test
%! m  = fitlm ([1;1;1;2;2;2;3;3;3], [2.1;2.3;1.9;4.1;3.9;4.2;6.3;5.8;6.1], ...
%!             'linear', 'CategoricalVars', 1);
%! cm = compact (m);
%! ci = coefCI (cm);
%! assert_equal (size (ci), [3, 2]);
%! assert_equal (ci(1,1), 1.809712563216694, 1e-10);
%! assert_equal (ci(1,2), 2.390287436783304, 1e-10);
%! assert_equal (ci(2,1), 1.556138236581195, 1e-10);
%! assert_equal (ci(2,2), 2.377195096752140, 1e-10);
%! assert_equal (ci(3,1), 3.556138236581195, 1e-10);
%! assert_equal (ci(3,2), 4.377195096752140, 1e-10);

%!test
%! m  = fitlm (X, y, 'RobustOpts', 'bisquare');
%! cm = compact (m);
%! ci = coefCI (cm);
%! assert_equal (cm.DFE, 17);
%! assert_equal (ci(1,1), -0.136385388374896, 1e-10);
%! assert_equal (ci(1,2),  0.378422288262478, 1e-10);
%! assert_equal (ci(2,1),  1.359092508160098, 1e-10);
%! assert_equal (ci(2,2),  3.617198504352038, 1e-10);
%! assert_equal (ci(3,1), -1.030210688187146, 1e-10);
%! assert_equal (ci(3,2), -0.925762726293341, 1e-10);
%! ci = coefCI (cm, 0.1);
%! assert_equal (ci(1,1), -0.091218796364050, 1e-10);
%! assert_equal (ci(1,2),  0.333255696251631, 1e-10);
%! assert_equal (ci(2,1),  1.557207176755238, 1e-10);
%! assert_equal (ci(2,2),  3.419083835756898, 1e-10);
%! assert_equal (ci(3,1), -1.021046958321974, 1e-10);
%! assert_equal (ci(3,2), -0.934926456158514, 1e-10);

%!test
%! m  = fitlm (X, y, 'constant');
%! cm = compact (m);
%! ci = coefCI (cm);
%! t  = tinv (0.975, cm.DFE);
%! assert_equal (size (ci), [1, 2]);
%! assert_equal (ci(1,1), -8.184528886493887, 1e-10);
%! assert_equal (ci(1,2), -2.995506675817716, 1e-10);
%! assert_equal ((ci(1,1) + ci(1,2)) / 2, cm.Coefficients.Estimate, 1e-10);
%! assert_equal (ci(1,2) - ci(1,1), 2 * t * cm.Coefficients.SE, 1e-10);

%!test
%! [p, F, r] = coefTest (cmdl);
%! assert_equal (size (p), [1, 1]);
%! assert_equal (class (p), 'double');
%! assert_equal (p >= 0 && p <= 1, true);
%! assert_equal (F >= 0, true);
%! assert_equal (p, 9.489880832170599e-28, -1e-8);
%! assert_equal (F, 1.283149098426142e+04, -1e-8);
%! assert_equal (r, 2);

%!test
%! k = cmdl.NumCoefficients;
%! H = [zeros(k-1, 1), eye(k-1)];
%! [p, F, r] = coefTest (cmdl, H);
%! assert_equal (p, 9.489880832170599e-28, -1e-8);
%! assert_equal (F, 1.283149098426142e+04, -1e-8);
%! assert_equal (r, 2);

%!test
%! [p, F, r] = coefTest (cmdl, [1 0 0]);
%! assert_equal (size (r), [1, 1]);
%! assert_equal (p, 0.314859866747774, -1e-8);
%! assert_equal (F, 1.072634101844537, -1e-8);
%! assert_equal (r, 1);
%! [p, F, r] = coefTest (cmdl, [0 1 0]);
%! assert_equal (p, 8.937794169018252e-05, -1e-8);
%! assert_equal (F, 25.985840929474932, -1e-8);
%! assert_equal (r, 1);
%! [p, F, r] = coefTest (cmdl, [0 0 1]);
%! assert_equal (p, 8.656938305821102e-19, -1e-8);
%! assert_equal (F, 1.849410599855684e+03, -1e-8);
%! assert_equal (r, 1);
%! [p, F, r] = coefTest (cmdl, [0 1 0; 0 0 1]);
%! assert_equal (p, 9.489880832170599e-28, -1e-8);
%! assert_equal (F, 1.283149098426142e+04, -1e-8);
%! assert_equal (r, 2);

%!test
%! b = cmdl.Coefficients.Estimate;
%! [p, F] = coefTest (cmdl, [0 1 0], b(2));
%! assert_equal (p, 1, 1e-10);
%! assert_equal (F, 0, 1e-10);
%! [p, F] = coefTest (cmdl, [0 1 0], 0);
%! assert_equal (p, 8.937794169018252e-05, -1e-8);
%! assert_equal (F, 25.985840929474932, -1e-8);

%!test
%! [p, F, r] = coefTest (cmdl, [0 1 0; 0 0 1], [1.5; -1.0]);
%! assert_equal (p, 2.833788304242915e-09, -1e-8);
%! assert_equal (F, 77.603887650386312, -1e-8);
%! assert_equal (r, 2);
%! [p, F] = coefTest (cmdl, [0 1 0], 1.5);
%! assert_equal (p, 0.056184159363707, -1e-8);
%! assert_equal (F, 4.199865537706047, -1e-8);

%!test
%! m  = fitlm (X, y, 'Intercept', false);
%! cm = compact (m);
%! [p, F, r] = coefTest (cm);
%! assert_equal (r, cm.NumCoefficients);
%! assert_equal (p, 6.060655830723051e-32, -1e-8);
%! assert_equal (F, 2.646694317541346e+04, -1e-8);

%!test
%! m  = fitlm (X, y, 'interactions');
%! cm = compact (m);
%! [p, F, r] = coefTest (cm);
%! assert_equal (r, cm.NumCoefficients - 1);
%! assert_equal (r != cm.NumPredictors, true);
%! assert_equal (p, 1.164196605688161e-25, -1e-8);
%! assert_equal (F, 8.107508574885546e+03, -1e-8);

%!test
%! m  = fitlm (X, y, 'Weights', (1:n)' / sum (1:n));
%! cm = compact (m);
%! [p, F, r] = coefTest (cm);
%! assert_equal (p, 1.481920976389473e-27, -1e-8);
%! assert_equal (F, 1.217557180481257e+04, -1e-8);
%! assert_equal (r, 2);

%!test
%! m  = fitlm ([1;1;1;2;2;2;3;3;3], [2.1;2.3;1.9;4.1;3.9;4.2;6.3;5.8;6.1], ...
%!             'linear', 'CategoricalVars', 1);
%! cm = compact (m);
%! [p, F, r] = coefTest (cm);
%! assert_equal (p, 1.197590680415813e-06, -1e-8);
%! assert_equal (F, 2.795000000000035e+02, -1e-8);
%! assert_equal (r, 2);
%! [p, F] = coefTest (cm, [1 0 0]);
%! assert_equal (p, 2.087464608380450e-06, -1e-8);
%! assert_equal (F, 3.133421052631613e+02, -1e-8);
%! [p, F] = coefTest (cm, [0 1 0]);
%! assert_equal (p, 2.325514143662469e-05, -1e-8);
%! assert_equal (F, 1.374078947368438e+02, -1e-8);
%! [p, F] = coefTest (cm, [0 0 1]);
%! assert_equal (p, 3.757733067786492e-07, -1e-8);
%! assert_equal (F, 5.589868421052698e+02, -1e-8);

%!test
%! m  = fitlm (X, y, 'constant');
%! cm = compact (m);
%! [p, F, r] = coefTest (cm);
%! assert_equal (p, 2.399364086950727e-04, -1e-8);
%! assert_equal (F, 20.335916494750592, -1e-8);
%! assert_equal (r, 1);

%!test
%! m    = fitlm ([ones(n,1), X, X(:,1)+X(:,2)], y);
%! cm   = compact (m);
%! [p, F] = coefTest (cm);
%! assert_equal (size (p), [1, 1]);
%! assert_equal (class (p), 'double');
%! assert_equal (isnan (p), true);
%! assert_equal (isnan (F), true);
%! drop = find (cm.Coefficients.SE == 0);
%! keep = setdiff (2:cm.NumCoefficients, drop');
%! H    = zeros (numel (keep), cm.NumCoefficients);
%! for i = 1:numel (keep)
%!   H(i, keep(i)) = 1;
%! endfor
%! [p, F, r] = coefTest (cm, H);
%! assert_equal (r, numel (keep));
%! assert_equal (p, 6.706570586430847e-30, -1e-8);
%! assert_equal (F, 1.771618642634559e+04, -1e-8);

%!test
%! m  = fitlm (X, y, 'RobustOpts', 'bisquare');
%! cm = compact (m);
%! [p, F, r] = coefTest (cm);
%! assert_equal (p, 3.941715170923545e-27, -1e-8);
%! assert_equal (F, 1.085097669445008e+04, -1e-8);
%! assert_equal (r, 2);
%! [p, F, r] = coefTest (cm, [0 1 -1]);
%! assert_equal (p, 9.729154060050210e-06, -1e-8);
%! assert_equal (F, 38.417457909307693, -1e-8);
%! assert_equal (r, 1);

%!test
%! yp = predict (cmdl, [0.5 0.25; 1.0 1.0; 0.2 0.04]);
%! assert_equal (class (yp), 'double');
%! assert_equal (size (yp), [3, 1]);
%! assert_equal (yp(1), 1.125705590619342, 1e-10);
%! assert_equal (yp(2), 1.645804838535884, 1e-10);
%! assert_equal (yp(3), 0.578725562711373, 1e-10);

%!test
%! [yp, yci] = predict (cmdl, [0.5 0.25; 1.0 1.0; 0.2 0.04]);
%! assert_equal (size (yci), [3, 2]);
%! assert_equal (all (yci(:,1) < yci(:,2)), true);
%! assert_equal (yci(1,1), 0.810180780547058, 1e-9);
%! assert_equal (yci(1,2), 1.441230400691626, 1e-9);
%! assert_equal (yci(2,1), 0.858229321851332, 1e-9);
%! assert_equal (yci(2,2), 2.433380355220436, 1e-9);
%! assert_equal (yci(3,1), 0.470499753577336, 1e-9);
%! assert_equal (yci(3,2), 0.686951371845409, 1e-9);

%!test
%! [~, yci] = predict (cmdl, [0.5 0.25; 1.0 1.0; 0.2 0.04], 'Alpha', 0.01);
%! assert_equal (yci(1,1), 0.692272619569794, 1e-9);
%! assert_equal (yci(1,2), 1.559138561668890, 1e-9);
%! assert_equal (yci(2,1), 0.563920989071667, 1e-9);
%! assert_equal (yci(2,2), 2.727688688000101, 1e-9);
%! assert_equal (yci(3,1), 0.430056955680247, 1e-9);
%! assert_equal (yci(3,2), 0.727394169742498, 1e-9);

%!test
%! [~, yci] = predict (cmdl, [0.5 0.25; 1.0 1.0; 0.2 0.04], 'Simultaneous', true);
%! assert_equal (yci(1,1), 0.662572505689110, 1e-9);
%! assert_equal (yci(1,2), 1.588838675549574, 1e-9);
%! assert_equal (yci(2,1), 0.489787095987915, 1e-9);
%! assert_equal (yci(2,2), 2.801822581083853, 1e-9);
%! assert_equal (yci(3,1), 0.419869741383617, 1e-9);
%! assert_equal (yci(3,2), 0.737581384039129, 1e-9);

%!test
%! [~, yci] = predict (cmdl, [0.5 0.25; 1.0 1.0; 0.2 0.04], 'Prediction', 'observation');
%! assert_equal (yci(1,1), 0.677632064105876, 1e-9);
%! assert_equal (yci(1,2), 1.573779117132808, 1e-9);
%! assert_equal (yci(2,1), 0.796399650258815, 1e-9);
%! assert_equal (yci(2,2), 2.495210026812952, 1e-9);
%! assert_equal (yci(3,1), 0.242679724835377, 1e-9);
%! assert_equal (yci(3,2), 0.914771400587368, 1e-9);

%!test
%! [~, yci] = predict (cmdl, [0.5 0.25; 1.0 1.0; 0.2 0.04], ...
%!                      'Alpha', 0.1, 'Simultaneous', true, 'Prediction', 'observation');
%! assert_equal (yci(1,1), 0.551414812037842, 1e-9);
%! assert_equal (yci(1,2), 1.699996369200842, 1e-9);
%! assert_equal (yci(2,1), 0.557131801540151, 1e-9);
%! assert_equal (yci(2,2), 2.734477875531617, 1e-9);
%! assert_equal (yci(3,1), 0.148019407463707, 1e-9);
%! assert_equal (yci(3,2), 1.009431717959039, 1e-9);

%!test
%! [yp, yci] = predict (cmdl, [0.5 0.25; NaN 1.0; 1.0 1.0]);
%! assert_equal (isnan (yp(2)), true);
%! assert_equal (all (isnan (yci(2,:))), true);
%! assert_equal (yp(1), 1.125705590619342, 1e-10);
%! assert_equal (yp(3), 1.645804838535884, 1e-10);
%! assert_equal (yci(1,1), 0.810180780547058, 1e-9);
%! assert_equal (yci(3,2), 2.433380355220436, 1e-9);

%!test
%! Xt = table (0.5, 0.25, 'VariableNames', {'x1', 'x2'});
%! yp = predict (cmdl, Xt);
%! assert_equal (yp, 1.125705590619342, 1e-10);

%!test
%! m  = fitlm ([1;1;1;2;2;2;3;3;3], [2.1;2.3;1.9;4.1;3.9;4.2;6.3;5.8;6.1], ...
%!             'linear', 'CategoricalVars', 1);
%! cm = compact (m);
%! yp = predict (cm, table ([1;2;3], 'VariableNames', {'x1'}));
%! assert_equal (yp(1), 2.099999999999999, 1e-10);
%! assert_equal (yp(2), 4.066666666666666, 1e-10);
%! assert_equal (yp(3), 6.066666666666666, 1e-10);

%!test
%! m  = fitlm (X, y, 'Weights', (1:n)' / sum (1:n));
%! cm = compact (m);
%! [yp, yci] = predict (cm, [0.5 0.25; 1.0 1.0; 0.2 0.04], 'Alpha', 0.05);
%! assert_equal (yp(1), 1.158333573705442, 1e-10);
%! assert_equal (yp(2), 1.744086690026939, 1e-10);
%! assert_equal (yp(3), 0.570596988527903, 1e-10);
%! assert_equal (yci(1,1), 0.802165170771357, 1e-9);
%! assert_equal (yci(2,2), 2.788483587522537, 1e-9);

%!test
%! m  = fitlm (X, y, 'RobustOpts', 'bisquare');
%! cm = compact (m);
%! [yp, yci] = predict (cm, [0.5 0.25; 1.0 1.0; 0.2 0.04], 'Simultaneous', true, 'Alpha', 0.1);
%! assert_equal (yp(1), 1.120594526261764, 1e-10);
%! assert_equal (yp(2), 1.631177248959615, 1e-10);
%! assert_equal (yp(3), 0.579528082905394, 1e-10);
%! assert_equal (yci(1,1), 0.680801249227337, 1e-9);
%! assert_equal (yci(2,2), 2.728936938016809, 1e-9);

%!test
%! m  = fitlm (X, y, 'quadratic');
%! cm = compact (m);
%! [yp, yci] = predict (cm, [0.5 0.25; 1.0 1.0; 0.2 0.04]);
%! assert_equal (yp(1), -0.948865258803113, 1e-9);
%! assert_equal (yp(2), -3.349087980348939, 1e-9);
%! assert_equal (yp(3), -0.053659932832480, 1e-9);
%! assert_equal (yci(1,1), -3.431959757763334, 1e-9);
%! assert_equal (yci(1,2), 1.534229240157108, 1e-9);

%!test
%! ysim = random (cmdl, [0.5 0.25; 1.0 1.0]);
%! assert_equal (size (ysim), [2, 1]);
%! assert_equal (class (ysim), 'double');
%! assert_equal (iscolumn (ysim), true);
%! ypred = predict (cmdl, [0.5 0.25; 1.0 1.0]);
%! assert_equal (ypred(1), 1.125705590619342, 1e-10);
%! assert_equal (ypred(2), 1.645804838535884, 1e-10);
%! assert_equal (all (isfinite (ysim - ypred)), true);

%!test
%! assert_equal (size (random (cmdl, [0.5 0.25])), [1, 1]);

%!test
%! ysim = random (cmdl, [0.5 0.25; NaN 1.0; 1.0 1.0]);
%! assert_equal (size (ysim), [3, 1]);
%! assert_equal (isfinite (ysim(1)), true);
%! assert_equal (isnan (ysim(2)), true);
%! assert_equal (isfinite (ysim(3)), true);

%!test
%! ya = random (cmdl, [0.5 0.25]);
%! yb = random (cmdl, [0.5 0.25]);
%! assert_equal (isequal (ya, yb), false);

%!test
%! Xt = table (0.5, 0.25, 'VariableNames', {'x1', 'x2'});
%! assert_equal (size (random (cmdl, Xt)), [1, 1]);
%! assert_equal (all (isfinite (random (cmdl, Xt))), true);
%! ysim = random (cmdl, X);
%! assert_equal (size (ysim), [20, 1]);
%! assert_equal (sum (isnan (ysim)), 0);

%!test
%! mw  = compact (fitlm (X, y, 'Weights', (1:n)' / sum (1:n)));
%! mni = compact (fitlm (X, y, 'Intercept', false));
%! assert_equal (all (isfinite (random (mw, [0.5 0.25; 1.0 1.0]))), true);
%! assert_equal (all (isfinite (random (mni, [0.5 0.25; 1.0 1.0]))), true);

%!test
%! yf = feval (cmdl, [0.5 0.25; 1.0 1.0; 0.2 0.04]);
%! assert_equal (yf(1), 1.125705590619342, 1e-10);
%! assert_equal (yf(2), 1.645804838535884, 1e-10);
%! assert_equal (yf(3), 0.578725562711373, 1e-10);
%! assert_equal (feval (cmdl, [0.5; 1.0; 0.2], [0.25; 1.0; 0.04]), yf, 1e-10);

%!test
%! yf3 = feval (cmdl, [0.5, 1.0, 0.2], [0.25, 1.0, 0.04]);
%! assert_equal (size (yf3), [1, 3]);
%! assert_equal (yf3(1), 1.125705590619342, 1e-10);
%! assert_equal (yf3(2), 1.645804838535884, 1e-10);
%! assert_equal (yf3(3), 0.578725562711373, 1e-10);

%!test
%! assert_equal (feval (cmdl, 0.5, 0.25), 1.125705590619342, 1e-10);
%! yf5 = feval (cmdl, 0.5, [0.1; 0.2; 0.3]);
%! assert_equal (yf5(1), 1.272530890093120, 1e-10);
%! assert_equal (yf5(2), 1.174647357110602, 1e-10);
%! assert_equal (yf5(3), 1.076763824128083, 1e-10);
%! yf6 = feval (cmdl, [0.1; 0.5; 0.9], 0.25);
%! assert_equal (yf6(1), 0.122324994390997, 1e-10);
%! assert_equal (yf6(2), 1.125705590619342, 1e-10);
%! assert_equal (yf6(3), 2.129086186847688, 1e-10);

%!test
%! ms = compact (fitlm (X(:,1), y));
%! assert_equal (size (feval (ms, 0.5)), [1, 1]);
%! assert_equal (size (feval (ms, [0.3; 0.5; 0.9])), [3, 1]);
%! assert_equal (feval (ms, 0.5), predict (ms, 0.5), 1e-10);
%! assert_equal (feval (ms, [0.3; 0.5; 0.9]), predict (ms, [0.3; 0.5; 0.9]), 1e-10);
%! yf14 = feval (ms, [1; 2; 3]);
%! assert_equal (yf14(1), -14.162385738140875, 1e-9);
%! assert_equal (yf14(2), -32.209476173898921, 1e-9);
%! assert_equal (yf14(3), -50.256566609656964, 1e-9);

%!test
%! Xt = table (0.5, 0.25, 'VariableNames', {'x1', 'x2'});
%! assert_equal (feval (cmdl, Xt), 1.125705590619342, 1e-10);

%!test
%! yf9 = feval (cmdl, [0.5 0.25; NaN 1.0; 1.0 1.0]);
%! assert_equal (isnan (yf9(2)), true);
%! assert_equal (yf9(1), 1.125705590619342, 1e-10);
%! assert_equal (yf9(3), 1.645804838535884, 1e-10);
%! yf10 = feval (cmdl, [0.5; NaN; 1.0], [0.25; 1.0; 1.0]);
%! assert_equal (isnan (yf10(2)), true);
%! yf11 = feval (cmdl, [0.5; 1.0; 1.0], [0.25; NaN; 1.0]);
%! assert_equal (isnan (yf11(2)), true);

%!test
%! yf12 = feval (cmdl, X);
%! assert_equal (size (yf12), [20, 1]);
%! assert_equal (sum (isnan (yf12)), 0);

%!test
%! mw  = compact (fitlm (X, y, 'Weights', (1:n)' / sum (1:n)));
%! yfw = feval (mw, [0.5 0.25; 1.0 1.0]);
%! assert_equal (yfw(1), 1.158333573705442, 1e-10);
%! assert_equal (yfw(2), 1.744086690026939, 1e-10);
%! assert_equal (feval (mw, [0.5; 1.0], [0.25; 1.0]), yfw, 1e-10);

%!test
%! Weight = [2000;2100;2200;2300;2400;2500;2600;2700;2800;2900;3000; ...
%!           3100;3200;3300;3400;3500;3600;3700;3800;3900];
%! Year   = categorical ([70;70;70;70;70;76;76;76;76;76;76;76;82;82; ...
%!                        82;82;82;82;82;82]);
%! MPG    = [30;29;28;27;26;25;24;23;22;21;20;19;18;17;16;15;14;13;12;11];
%! m  = fitlm (table (MPG, Weight, Year), 'MPG ~ Weight + Year');
%! cm = compact (m);
%! yf = feval (cm, [2500;3000], '76');
%! assert_equal (yf(1), 25.000000000000000, 1e-9);
%! assert_equal (yf(2), 20.000000000000004, 1e-9);
%! assert_equal (yf, feval (m, [2500;3000], '76'), 1e-10);
%! yf2 = feval (cm, [2500;3000], categorical (70));
%! assert_equal (yf2(1), 24.999999999999996, 1e-9);
%! assert_equal (yf2(2), 20.000000000000000, 1e-9);
%! assert_equal (feval (cm, 2800, '82'), 21.999999999999996, 1e-9);
%! assert_equal (isnan (feval (cm, 2500, '99')), true);

%!test
%! fig = figure ('visible', 'off');
%! ax = axes (fig);
%! h = plotEffects (ax, cmdl);
%! xd1 = get (h(1), 'XData');
%! yd1 = get (h(1), 'YData');
%! xd2 = get (h(2), 'XData');
%! yd2 = get (h(2), 'YData');
%! xd3 = get (h(3), 'XData');
%! yd3 = get (h(3), 'YData');
%! ytl = get (ax, 'YTickLabel');
%! assert_equal (numel (h), 3);
%! assert_equal (xd1(1), 2.38302891604232, -1e-10);
%! assert_equal (xd1(2), -19.5277648300125, -1e-10);
%! assert_equal (yd1, [1 2]);
%! assert_equal (xd2(1), 1.39673712385796, -1e-10);
%! assert_equal (xd2(2), 3.36932070822668, -1e-10);
%! assert_equal (yd2, [1 1]);
%! assert_equal (xd3(1), -20.4857975891918, -1e-10);
%! assert_equal (xd3(2), -18.5697320708331, -1e-10);
%! assert_equal (yd3, [2 2]);
%! assert_equal (get (h(1), 'Color'), [0.1490 0.5490 0.8660], 1e-4);
%! assert_equal (get (h(2), 'Color'), [0.1490 0.5490 0.8660], 1e-4);
%! assert_equal (get (h(3), 'Color'), [0.1490 0.5490 0.8660], 1e-4);
%! assert_equal (get (h(1), 'Marker'), 'o');
%! assert_equal (get (h(1), 'LineStyle'), 'none');
%! assert_equal (get (h(2), 'LineStyle'), '-');
%! assert_equal (get (h(2), 'Marker'), 'none');
%! assert_equal (get (h(3), 'LineStyle'), '-');
%! assert_equal (get (h(3), 'Marker'), 'none');
%! assert_equal (mean (xd2), xd1(1), 1e-10);
%! assert_equal (mean (xd3), xd1(2), 1e-10);
%! assert_equal (get (get (ax, 'xlabel'), 'string'), 'Main Effect');
%! assert_equal (get (get (ax, 'ylabel'), 'string'), '');
%! assert_equal (get (get (ax, 'title'), 'string'), 'Main Effects Plot');
%! assert_equal (get (ax, 'YTick'), [1 2]);
%! assert_equal (ytl{1}, 'x1: 0.05 to 1');
%! assert_equal (ytl{2}, 'x2: 0.05 to 20');
%! close (fig);

%!test
%! ## 3-predictor model
%! X3 = [X, sin((1:n)' * pi / n)];
%! y3 = X3 * [3; -1; 2] + 0.1 * cos ((1:n)' * pi / 7);
%! cm3 = compact (fitlm (X3, y3));
%! fig = figure ('visible', 'off');
%! ax = axes (fig);
%! h = plotEffects (ax, cm3);
%! xd1 = get (h(1), 'XData');
%! yd1 = get (h(1), 'YData');
%! xd2 = get (h(2), 'XData');
%! yd2 = get (h(2), 'YData');
%! xd3 = get (h(3), 'XData');
%! yd3 = get (h(3), 'YData');
%! xd4 = get (h(4), 'XData');
%! yd4 = get (h(4), 'YData');
%! ytl = get (ax, 'YTickLabel');
%! assert_equal (numel (h), 4);
%! assert_equal (xd1(1), 8.10687671732127, -1e-10);
%! assert_equal (xd1(2), -25.4487243632125, -1e-10);
%! assert_equal (xd1(3), 0.661302203942261, -1e-10);
%! assert_equal (yd1, [1 2 3]);
%! assert_equal (xd2(1), 0.565266595687836, -1e-10);
%! assert_equal (xd2(2), 15.6484868389547, -1e-10);
%! assert_equal (yd2, [1 1]);
%! assert_equal (xd3(1), -33.3368582824351, -1e-10);
%! assert_equal (xd3(2), -17.5605904439899, -1e-10);
%! assert_equal (yd3, [2 2]);
%! assert_equal (xd4(1), -1.25582490831999, -1e-10);
%! assert_equal (xd4(2), 2.57842931620451, -1e-10);
%! assert_equal (yd4, [3 3]);
%! assert_equal (get (ax, 'YTick'), [1 2 3]);
%! assert_equal (ytl{1}, 'x1: 0.05 to 1');
%! assert_equal (ytl{2}, 'x2: 0.05 to 20');
%! assert_equal (ytl{3}, 'x3: 1.22465e-16 to 1');
%! assert_equal (mean (xd2), xd1(1), 1e-10);
%! assert_equal (mean (xd3), xd1(2), 1e-10);
%! assert_equal (mean (xd4), xd1(3), 1e-10);
%! close (fig);

%!test
%! cme = compact (fitlm (X, y, 'Exclude', [2, 7]));
%! fig = figure ('visible', 'off');
%! ax = axes (fig);
%! h = plotEffects (ax, cme);
%! xd1 = get (h(1), 'XData');
%! yd1 = get (h(1), 'YData');
%! xd2 = get (h(2), 'XData');
%! yd2 = get (h(2), 'YData');
%! xd3 = get (h(3), 'XData');
%! yd3 = get (h(3), 'YData');
%! ytl = get (ax, 'YTickLabel');
%! assert_equal (numel (h), 3);
%! assert_equal (xd1(1), 2.50035744908398, -1e-10);
%! assert_equal (xd1(2), -19.5912988214488, -1e-10);
%! assert_equal (yd1, [1 2]);
%! assert_equal (xd2(1), 1.40421088339552, -1e-10);
%! assert_equal (xd2(2), 3.59650401477245, -1e-10);
%! assert_equal (yd2, [1 1]);
%! assert_equal (xd3(1), -20.6333076647782, -1e-10);
%! assert_equal (xd3(2), -18.5492899781194, -1e-10);
%! assert_equal (yd3, [2 2]);
%! assert_equal (ytl{1}, 'x1: 0.05 to 1');
%! assert_equal (ytl{2}, 'x2: 0.05 to 20');
%! assert_equal (mean (xd2), xd1(1), 1e-10);
%! assert_equal (mean (xd3), xd1(2), 1e-10);
%! close (fig);

%!test
%! cmw = compact (fitlm (X, y, 'Weights', (1:n)' / sum (1:n)));
%! fig = figure ('visible', 'off');
%! ax = axes (fig);
%! h = plotEffects (ax, cmw);
%! xd1 = get (h(1), 'XData');
%! yd1 = get (h(1), 'YData');
%! xd2 = get (h(2), 'XData');
%! yd2 = get (h(2), 'YData');
%! xd3 = get (h(3), 'XData');
%! yd3 = get (h(3), 'YData');
%! ytl = get (ax, 'YTickLabel');
%! assert_equal (numel (h), 3);
%! assert_equal (xd1(1), 2.51587141860715, -1e-10);
%! assert_equal (xd1(2), -19.6411669663483, -1e-10);
%! assert_equal (yd1, [1 2]);
%! assert_equal (xd2(1), 1.08491557053384, -1e-10);
%! assert_equal (xd2(2), 3.94682726668046, -1e-10);
%! assert_equal (yd2, [1 1]);
%! assert_equal (xd3(1), -20.8383905241664, -1e-10);
%! assert_equal (xd3(2), -18.4439434085302, -1e-10);
%! assert_equal (yd3, [2 2]);
%! assert_equal (ytl{1}, 'x1: 0.05 to 1');
%! assert_equal (ytl{2}, 'x2: 0.05 to 20');
%! assert_equal (mean (xd2), xd1(1), 1e-10);
%! assert_equal (mean (xd3), xd1(2), 1e-10);
%! close (fig);

%!test
%! cmni = compact (fitlm (X, y, 'Intercept', false));
%! fig = figure ('visible', 'off');
%! ax = axes (fig);
%! h = plotEffects (ax, cmni);
%! xd1 = get (h(1), 'XData');
%! yd1 = get (h(1), 'YData');
%! xd2 = get (h(2), 'XData');
%! yd2 = get (h(2), 'YData');
%! xd3 = get (h(3), 'XData');
%! yd3 = get (h(3), 'YData');
%! ytl = get (ax, 'YTickLabel');
%! assert_equal (numel (h), 3);
%! assert_equal (xd1(1), 2.81335053251731, -1e-10);
%! assert_equal (xd1(2), -19.8951125513936, -1e-10);
%! assert_equal (yd1, [1 2]);
%! assert_equal (xd2(1), 2.36234515544211, -1e-10);
%! assert_equal (xd2(2), 3.26435590959250, -1e-10);
%! assert_equal (yd2, [1 1]);
%! assert_equal (xd3(1), -20.4919734818287, -1e-10);
%! assert_equal (xd3(2), -19.2982516209584, -1e-10);
%! assert_equal (yd3, [2 2]);
%! assert_equal (ytl{1}, 'x1: 0.05 to 1');
%! assert_equal (ytl{2}, 'x2: 0.05 to 20');
%! assert_equal (mean (xd2), xd1(1), 1e-10);
%! assert_equal (mean (xd3), xd1(2), 1e-10);
%! close (fig);

%!test
%! fig = figure ('visible', 'off');
%! ax = axes (fig);
%! h = plotEffects (ax, cmdl);
%! assert_equal (isequal (get (h(1), 'Parent'), ax), true);
%! assert_equal (get (h(1), 'XData'), [2.38302891604232, -19.5277648300125], -1e-10);
%! close (fig);

%!test
%! fig = figure ('visible', 'off');
%! h = plotEffects (cmdl);
%! assert_equal (isequal (get (h(1), 'Parent'), gca ()), true);
%! assert_equal (get (h(1), 'XData'), [2.38302891604232, -19.5277648300125], -1e-10);
%! close (fig);

%!test
%! h1 = plotEffects (mdl);
%! h2 = plotEffects (cmdl);
%! assert_equal (get (h1(1), 'XData'), get (h2(1), 'XData'), 1e-10);
%! assert_equal (get (h1(2), 'XData'), get (h2(2), 'XData'), 1e-10);
%! assert_equal (get (h1(3), 'XData'), get (h2(3), 'XData'), 1e-10);
%! close all;

%!error <CompactLinearModel: invalid model object.> CompactLinearModel (123)
%!error <() indexing is not supported> cmdl(1)
%!error <{} indexing is not supported> cmdl{1}
%!error <unknown property> cmdl.NotAProperty
%!error <unknown property> cmdl.Fitted
%!error <unknown property> cmdl.ObservationInfo
%!error <unknown property> cmdl.Steps
%!error <too many inputs> coefCI (cmdl, 0.05, 'extra')
%!error <Value must be less than or equal to 1> coefCI (cmdl, 1.5)
%!error <Value must be greater than or equal to 0> coefCI (cmdl, -0.1)
%!error <Value must be greater than or equal to 0> coefCI (cmdl, NaN)
%!error <Value must be a scalar> coefCI (cmdl, [0.01 0.05])
%!error <Value must be a scalar> coefCI (cmdl, 'abc')
%!error <H must be a 1-by-3 numeric matrix> coefTest (cmdl, [1 0])
%!error <H must be a 1-by-3 numeric matrix> coefTest (cmdl, 'abc')
%!error <C must be a numeric vector> coefTest (cmdl, [0 1 0], 'abc')
%!error <H must be a 1-by-3 numeric matrix> coefTest (cmdl, [0 1 0; 0 0 1], [1])
%!error <H is not full rank> coefTest (cmdl, [0 NaN 0])
%!error <Too many input arguments> coefTest (cmdl, [0 1 0], 0, 'extra')
%!error <too many outputs> [a, b, c, d] = coefTest (cmdl)
%!error <Not enough input arguments> predict (cmdl)
%!error <unknown option> predict (cmdl, [0.5 0.25], 'BadOption', 1)
%!error <Prediction must be> predict (cmdl, [0.5 0.25], 'Prediction', 'bad')
%!error <Xnew must have 2 columns> predict (cmdl, ones (3, 5))
%!error <Xnew must have 2 columns> predict (cmdl, ones (3, 1))
%!error <missing predictor> predict (cmdl, table ([1;2], 'VariableNames', {'z'}))
%!error <Not enough input arguments> random (cmdl)
%!error <Too many input arguments> random (cmdl, [0.5 0.25], 'extra')
%!error <Xnew must have 2 columns> random (cmdl, ones (3, 5))
%!error <Xnew must have 2 columns> random (cmdl, [])
%!error <Not enough input arguments> feval (cmdl)
%!error <Incorrect number of input arguments> feval (cmdl, [0.5;1.0], [0.25;1.0], [0.1;0.2])
%!error <Predictor data matrix must have 2 columns> feval (cmdl, ones (3, 1))
%!error <All input arguments must be the same size> feval (cmdl, [0.5;1.0;0.2], [0.25;1.0])
%!error <X does not contain one or more predictor> feval (cmdl, table ([1;2], 'VariableNames', {'z'}))
%!error <Predictor data matrix must have 2 columns> feval (cmdl, [])
%!error <is not categorical> feval (cmdl, '2500', 0.25)
%!error <Wrong number of arguments> plotEffects (cmdl, 'extra')
%!error <Wrong number of arguments> plotEffects (cmdl, 'a', 'b')
%!error <Model has no predictors> plotEffects (compact (fitlm (X(:,1), y, 'constant')))
%!error <Not enough input arguments> plotInteraction (cmdl)
%!error <Not enough input arguments> plotInteraction (cmdl, 'x1')
%!error <PTYPE must be> plotInteraction (cmdl, 'x1', 'x2', 'badtype')
%!error <Too many input arguments> plotInteraction (cmdl, 'x1', 'x2', 'effects', 'extra')
%!error <is not a variable for this fit> plotInteraction (cmdl, 'z', 'x2')
%!error <is not a variable for this fit> plotInteraction (cmdl, 'x1', 'z')
%!error <This model only contains> plotInteraction (cmdl, 99, 'x2')
%!error <Variable must be specified as a name or a positive integer> plotInteraction (cmdl, 1.5, 'x2')
%!error <is the response in this model> plotInteraction (cmdl, 'y', 'x2')
%!error <is the response in this model> plotInteraction (cmdl, 'x1', 'y')
%!error <VAR1 and VAR2 must be different variables> plotInteraction (cmdl, 'x1', 'x1')
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
        fprintf ("\n  Coefficients:\n\n");
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

  endmethods

endclassdef

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

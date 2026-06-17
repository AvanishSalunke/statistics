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

classdef LinearModel

  properties (GetAccess = public, SetAccess = protected)

    ## Coefficient estimate properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} CoefficientCovariance
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
    ## @deftp {LinearModel} {property} CoefficientNames
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
    ## @deftp {LinearModel} {property} Coefficients
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
    ## @deftp {LinearModel} {property} NumCoefficients
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
    ## @deftp {LinearModel} {property} NumEstimatedCoefficients
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

    ## Summary statistic properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} DFE
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
    ## @deftp {LinearModel} {property} Diagnostics
    ##
    ## Observation diagnostics
    ##
    ## A table with one row per observation and seven columns:
    ## @itemize
    ## @item @code{Leverage} - diagonal of the hat matrix @math{H}
    ## @item @code{CooksDistance} - Cook's distance, a measure of scaled
    ##   change in fitted values
    ## @item @code{Dffits} - delete-1 scaled differences in fitted values
    ## @item @code{S2_i} - delete-1 residual variance estimate
    ## @item @code{CovRatio} - ratio of the determinant of the coefficient
    ##   covariance matrix with and without each observation
    ## @item @code{Dfbetas} - @math{n}-by-@math{p} matrix of scaled changes
    ##   in coefficient estimates when each observation is deleted in turn
    ## @item @code{HatMatrix} - @math{n}-by-@math{n} projection matrix such
    ##   that @code{Fitted = HatMatrix * y}
    ## @end itemize
    ## Rows not used in fitting have @code{NaN} in @code{CooksDistance},
    ## @code{Dffits}, @code{S2_i}, and @code{CovRatio}, and zeros in
    ## @code{Leverage}, @code{Dfbetas}, and @code{HatMatrix}.  This property
    ## is read-only.
    ##
    ## @end deftp
    Diagnostics = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Fitted
    ##
    ## Fitted response values
    ##
    ## An @math{n}-by-1 numeric vector of predicted response values based on
    ## the training data, where @math{n} is the total number of observations
    ## including excluded and missing rows, which contain @code{NaN}.  Use
    ## @code{predict} to obtain predictions for new data or to compute
    ## confidence bounds.  This property is read-only.
    ##
    ## @end deftp
    Fitted = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} LogLikelihood
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
    ## @deftp {LinearModel} {property} ModelCriterion
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
    ## @deftp {LinearModel} {property} ModelFitVsNullModel
    ##
    ## F-test of the fitted model versus the null model
    ##
    ## A structure with three fields:
    ## @itemize
    ## @item @code{Fstat} - F-statistic of the fitted model versus a null
    ##   model containing only a constant term
    ## @item @code{Pvalue} - p-value for the F-statistic
    ## @item @code{NullModel} - character vector describing the null model
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    ModelFitVsNullModel = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} MSE
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
    ## @deftp {LinearModel} {property} Residuals
    ##
    ## Residuals for the fitted model
    ##
    ## A table with one row per observation and four columns:
    ## @itemize
    ## @item @code{Raw} - observed minus fitted values
    ## @item @code{Pearson} - raw residuals divided by @code{RMSE}
    ## @item @code{Standardized} - internally studentized residuals; raw
    ##   residuals divided by their estimated standard deviation using the
    ##   full-model @code{MSE}
    ## @item @code{Studentized} - externally studentized residuals; each raw
    ##   residual divided by an estimate of the standard deviation based on
    ##   all observations except that one, using the delete-1 @code{S2_i}
    ## @end itemize
    ## Rows not used in the fit contain @code{NaN}.  This property is
    ## read-only.
    ##
    ## @end deftp
    Residuals = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} RMSE
    ##
    ## Root mean squared error
    ##
    ## A scalar numeric value equal to @math{sqrt(MSE)}.  This property is
    ## read-only.
    ##
    ## @end deftp
    RMSE = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Rsquared
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
    ## @deftp {LinearModel} {property} SSE
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
    ## @deftp {LinearModel} {property} SSR
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
    ## @deftp {LinearModel} {property} SST
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


    ## Fitting method properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Robust
    ##
    ## Robust fit information
    ##
    ## A structure with three fields:
    ## @itemize
    ## @item @code{WgtFun} - robust weighting function name, e.g.
    ##   @qcode{'bisquare'}
    ## @item @code{Tune} - tuning constant; empty if @code{WgtFun} is
    ##   @qcode{'ols'} or a function handle with the default tuning constant
    ## @item @code{Weights} - vector of final iteration weights; empty for
    ##   a @code{CompactLinearModel} object
    ## @end itemize
    ## This structure is empty unless the model was fit using robust
    ## regression.  This property is read-only.
    ##
    ## @end deftp
    Robust = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Steps
    ##
    ## Stepwise fitting information
    ##
    ## A structure with seven fields:
    ## @itemize
    ## @item @code{Start} - formula string of the starting model
    ## @item @code{Lower} - formula string of the lower-bound model; terms
    ##   listed here cannot be removed
    ## @item @code{Upper} - formula string of the upper-bound model; the
    ##   model cannot grow beyond this
    ## @item @code{Criterion} - criterion used, e.g. @qcode{'sse'}
    ## @item @code{PEnter} - threshold for adding a term
    ## @item @code{PRemove} - threshold for removing a term
    ## @item @code{History} - table with one row per step and columns
    ##   @code{Action}, @code{TermName}, @code{Terms}, @code{DF},
    ##   @code{delDF}, @code{FStat}, @code{PValue}
    ## @end itemize
    ## This structure is empty unless the model was fit using stepwise
    ## regression.  This property is read-only.
    ##
    ## @end deftp
    Steps = [];


    ## Input data properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Formula
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
    ## @deftp {LinearModel} {property} NumObservations
    ##
    ## Number of observations used in the fit
    ##
    ## A positive integer giving the number of observations actually used in
    ## fitting.  Rows with missing values and rows excluded via the
    ## @code{'Exclude'} name-value argument are not counted.  This property
    ## is read-only.
    ##
    ## @end deftp
    NumObservations = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} NumPredictors
    ##
    ## Number of predictor variables
    ##
    ## A positive integer giving the number of predictor variables used to
    ## fit the model.  This property is read-only.
    ##
    ## @end deftp
    NumPredictors = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} NumVariables
    ##
    ## Number of variables in the input data
    ##
    ## A positive integer giving the total number of variables in the input
    ## data, counting predictors, the response, and any unused columns.
    ## This property is read-only.
    ##
    ## @end deftp
    NumVariables = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} ObservationInfo
    ##
    ## Per-observation metadata
    ##
    ## An @math{n}-by-4 table where @math{n} is the total number of rows in
    ## the input data.  The four columns are:
    ## @itemize
    ## @item @code{Weights} - observation weight, default is 1
    ## @item @code{Excluded} - logical; true if excluded via the
    ##   @code{'Exclude'} argument
    ## @item @code{Missing} - logical; true if the row contains any
    ##   @code{NaN} value
    ## @item @code{Subset} - logical; true if the observation was used in
    ##   the fit, i.e. not excluded and not missing
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    ObservationInfo = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} ObservationNames
    ##
    ## Observation names
    ##
    ## A cell array of character vectors containing the names of the
    ## observations.  If the fit was based on a table that has row names,
    ## this property holds those names.  Otherwise it is an empty cell array.
    ## This property is read-only.
    ##
    ## @end deftp
    ObservationNames = {};

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} PredictorNames
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
    ## @deftp {LinearModel} {property} ResponseName
    ##
    ## Response variable name
    ##
    ## A character vector containing the name of the response variable.
    ## This property is read-only.
    ##
    ## @end deftp
    ResponseName = '';

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} VariableInfo
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
    ## @deftp {LinearModel} {property} VariableNames
    ##
    ## Names of all variables in the input data
    ##
    ## A cell array of character vectors containing the names of all
    ## variables, including predictors, the response, and unused variables.
    ## For table input these are the table column names.  For matrix input
    ## these are the values given by @code{'VarNames'}, defaulting to
    ## @qcode{@{'x1','x2',...,'xp','y'@}}.  This property is read-only.
    ##
    ## @end deftp
    VariableNames = {};

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Variables
    ##
    ## Input data as a table
    ##
    ## A table containing predictor and response values for all observations,
    ## including unused variables.  For table input this is the full input
    ## table.  For matrix input this is a table constructed from the
    ## predictor matrix and response vector.  This property is read-only.
    ##
    ## @end deftp
    Variables = [];

  endproperties

  properties (Access = private, Hidden)

    ## Full design matrix, n by p_design, used for predictions
    DesignMatrix = [];

    ## Column indices of active coefficients in the design matrix
    ActiveCols = [];

    ## Whether the model includes an intercept term
    HasIntercept = true;

    ## Response vector, full n by 1 with NaN for non-subset rows
    ResponseVector = [];

    ## Full n by 1 observation weights
    WeightVector = [];

    ## n by 1 logical mask: true for rows used in the fit
    SubsetMask = [];

    ## Terms matrix from modelspec or lm_parse_modelspec
    TermsMatrix = [];

    ## Categorical level info for re-encoding in predict
    CatLevelInfo = [];

    ## Predictor names after categorical dummy expansion
    EncPredictorNames = {};

    ## Encoded predictor matrix (Path B only), cached for refit
    EncodedPredMatrix = [];

    ## Parsed NV options stored for refit operations
    OrigOpts = [];

  endproperties

  methods (Hidden)

    ## Custom display
    function display (this)
      in_name = inputname (1);
      if (! isempty (in_name))
        fprintf ('%s =\n', in_name);
      endif
      disp (this);
    endfunction

    ## Custom display
    function disp (this)
      fprintf ("\n  Linear regression model:\n");
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
          error (["LinearModel: () indexing is not supported.  " ...
                  "Use dot notation to access properties."]);
        case '{}'
          error (["LinearModel: {} indexing is not supported.  " ...
                  "Use dot notation to access properties."]);
        case '.'
          if (! ischar (s.subs))
            error ("LinearModel.subsref: property name must be a character vector.");
          endif

          ## Allow normal execution if the user is calling a class method
          if (ismethod (this, s.subs))
            [varargout{1:nargout}] = builtin ('subsref', this, [s, chain_s]);
            return;
          endif
          try
            out = this.(s.subs);
          catch
            error ("LinearModel.subsref: unknown property '%s'.", s.subs);
          end_try_catch
      endswitch
      if (! isempty (chain_s))
        out = subsref (out, chain_s);
      endif
      varargout{1} = out;
    endfunction

  endmethods

  methods (Access = public)

    ## Class Constructor
    function this = LinearModel (varargin)
      ##   LinearModel (X, y, modelspec, NV...)
      ##   LinearModel (tbl, resp_input, modelspec, NV...)

      if (nargin == 0)
        return;
      endif

      data       = varargin{1};
      resp_input = varargin{2};
      modelspec  = varargin{3};
      nv_args    = varargin(4:end);

      opts       = LinearModel.lm_parse_nv (nv_args);
      is_formula = ischar (modelspec) && any (modelspec == '~');

      if (! istable (data))
        X_raw   = double (data);
        n_total = size (X_raw, 1);
        p_raw   = size (X_raw, 2);
        y_full  = double (resp_input(:));

        if (! isempty (opts.VarNames))
          if (numel (opts.VarNames) != p_raw + 1)
            error ('LinearModel: VarNames must have %d elements.', p_raw + 1);
          endif
          pred_names_raw = opts.VarNames(1:p_raw);
          resp_name      = opts.VarNames{end};
        else
          pred_names_raw = arrayfun (@(k) sprintf ('x%d', k), 1:p_raw, ...
                                     'UniformOutput', false);
          resp_name      = 'y';
        endif
        if (! isempty (opts.ResponseVar))
          resp_name = opts.ResponseVar;
        endif
        var_names_all = [pred_names_raw, {resp_name}];
        n_vars        = p_raw + 1;

      else ## 'table'
        tbl           = data;
        col_names     = tbl.Properties.VariableNames;
        n_total       = height (tbl);
        n_vars        = width (tbl);
        var_names_all = col_names;

        if (ischar (resp_input) && ! isempty (resp_input))
          resp_name = resp_input;
        elseif (isstring (resp_input) && ! isempty (resp_input))
          resp_name = char (resp_input);
        elseif (isnumeric (resp_input) && ! isempty (resp_input))
          resp_name = 'y';
          if (! isempty (opts.ResponseVar))
            resp_name = opts.ResponseVar;
          endif
          y_ext = double (resp_input(:));
        elseif (is_formula)
          tparts    = strsplit (modelspec, '~');
          resp_name = strtrim (tparts{1});
        else
          resp_name = col_names{end};
        endif

        if (! isempty (opts.PredictorVars))
          pred_names_raw = opts.PredictorVars;
        else
          pred_names_raw = col_names(! strcmp (col_names, resp_name));
        endif
        p_raw = numel (pred_names_raw);

        if (exist ('y_ext', 'var'))
          y_full = y_ext;
        else
          y_full = double (tbl.(resp_name)(:));
        endif
      endif

      ## categorical column flags
      cat_logical = false (1, p_raw);
      if (! isempty (opts.CategoricalVars))
        cv = opts.CategoricalVars;
        if (islogical (cv))
          n_cv = min (numel (cv), p_raw);
          cat_logical(1:n_cv) = cv(1:n_cv);
        elseif (isnumeric (cv))
          valid_cv = cv(cv > 0 & cv <= p_raw);
          cat_logical(valid_cv) = true;
        elseif (iscell (cv))
          for i = 1:numel (cv)
            cat_logical(strcmp (pred_names_raw, cv{i})) = true;
          endfor
        endif
      endif
      if (istable (data))
        for j = 1:p_raw
          col = tbl.(pred_names_raw{j});
          if (iscell (col) || isa (col, 'categorical'))
            cat_logical(j) = true;
          endif
        endfor
      endif

      ## missing and excluded masks
      if (! istable (data))
        missing_mask = any (isnan (X_raw), 2) | isnan (y_full);
      else
        missing_mask = any (ismissing (tbl), 2);
      endif

      excluded_mask = false (n_total, 1);
      if (! isempty (opts.Exclude))
        ex = opts.Exclude(:);
        if (islogical (ex))
          excluded_mask(1:numel (ex)) = ex;
        else
          excluded_mask(ex) = true;
        endif
      endif

      subset_mask = ! missing_mask & ! excluded_mask;
      n_obs       = sum (subset_mask);

      if (n_obs < 1)
        error ('LinearModel: No observations remain after removing missing/excluded rows.');
      endif

      ## weights
      if (isempty (opts.Weights))
        w_full = ones (n_total, 1);
      else
        w_full = double (opts.Weights(:));
      endif
      w_sub = w_full(subset_mask);

      if (is_formula)

        ## PATH A: Wilkinson formula string
        if (! istable (data))
          tbl_temp = array2table ([X_raw, y_full], 'VariableNames', var_names_all);
          tbl_sub  = tbl_temp(subset_mask, :);
        else
          tbl_sub = tbl(subset_mask, :);
        endif

        [X_design_sub, ~, coef_names_raw] = parseWilkinsonFormula ( ...
          modelspec, 'model_matrix', tbl_sub);

        coef_names    = coef_names_raw(:)';
        y_sub         = y_full(subset_mask);
        n_coef        = size (X_design_sub, 2);
        has_intercept = any (strcmp (coef_names, '(Intercept)'));
        enc_names     = coef_names(! strcmp (coef_names, '(Intercept)'));

        schema = parseWilkinsonFormula (modelspec, 'matrix');
        if (isfield (schema, 'Terms'))
          terms = schema.Terms;
        else
          terms = [];
        endif

        cat_info.names  = {};
        cat_info.levels = {};

      else

        ## PATH B: Keyword / numeric terms matrix
        X_num_full     = zeros (n_total, p_raw);
        cat_str_levels = cell (1, p_raw);

        for j = 1:p_raw
          if (istable (data))
            col = tbl.(pred_names_raw{j});
            if (iscell (col))
              [cat_str_levels{j}, ~, ic] = unique (col);
              X_num_full(:, j) = ic;
            elseif (isa (col, 'categorical'))
              cat_str_levels{j} = categories (col);
              [~, ic] = ismember (cellstr (col), cat_str_levels{j});
              X_num_full(:, j) = ic;
            else
              X_num_full(:, j) = double (col(:));
              cat_str_levels{j} = {};
            endif
          else
            X_num_full(:, j) = X_raw(:, j);
            if (cat_logical(j))
              uvals = sort (unique (X_raw(isfinite (X_raw(:,j)), j)));
              cat_str_levels{j} = cellstr (num2str (uvals(:)));
            else
              cat_str_levels{j} = {};
            endif
          endif
        endfor

        X_num_sub = X_num_full(subset_mask, :);
        y_sub     = y_full(subset_mask);

        [X_enc_sub, enc_names, cat_info] = LinearModel.lm_encode_categorical ( ...
          X_num_sub, cat_logical, pred_names_raw, cat_str_levels);
        p_enc  = size (X_enc_sub, 2);

        [terms, has_intercept, coef_names] = LinearModel.lm_parse_modelspec ( ...
          modelspec, enc_names, p_enc, opts.Intercept);
        n_coef = rows (terms);

        X_design_sub = LinearModel.lm_build_design (terms, X_enc_sub);

      endif

      fit = LinearModel.lm_fit (X_design_sub, y_sub, w_sub);
      D   = LinearModel.lm_diagnostics (X_design_sub, y_sub, fit);

      p    = fit.rank_X;
      SSE  = fit.SSE;
      SSR  = fit.SSR;
      SST  = fit.SST;
      DFE  = fit.DFE;
      MSE  = fit.MSE;
      RMSE = fit.RMSE;

      crit          = LinearModel.lm_criteria (fit, n_obs, has_intercept);
      LogLikelihood = crit.LogLikelihood;
      AIC           = crit.AIC;
      AICc          = crit.AICc;
      BIC           = crit.BIC;
      CAIC          = crit.CAIC;
      R2_ord        = crit.Rsquared;
      R2_adj        = crit.AdjRsquared;
      Fstat         = crit.Fstat;
      Fpval         = crit.Fpval;

      h        = fit.leverage;
      S2_i_sub = D.S2_i;

      Fitted_full = NaN (n_total, 1);
      Fitted_full(subset_mask) = fit.Fitted;

      Raw_full = NaN (n_total, 1);
      Raw_full(subset_mask) = fit.Raw;

      Pearson_sub = fit.Raw / sqrt (max (MSE, eps));
      Std_sub     = fit.Raw ./ (RMSE .* sqrt (max (1 - h, eps)));
      Stu_sub     = fit.Raw ./ (sqrt (max (S2_i_sub, eps)) .* sqrt (max (1 - h, eps)));

      Pearson_full = NaN (n_total, 1);
      Std_full     = NaN (n_total, 1);
      Stu_full     = NaN (n_total, 1);
      Pearson_full(subset_mask) = Pearson_sub;
      Std_full(subset_mask)     = Std_sub;
      Stu_full(subset_mask)     = Stu_sub;

      beta_full  = fit.beta;
      se_full    = zeros (n_coef, 1);
      tstat_full = NaN (n_coef, 1);
      pval_full  = NaN (n_coef, 1);
      active     = fit.active_cols;
      cov_diag   = diag (fit.CovBeta);

      se_full(active)    = sqrt (cov_diag(active));
      tstat_full(active) = beta_full(active) ./ se_full(active);
      pval_full(active)  = 2 * (1 - tcdf (abs (tstat_full(active)), DFE));

      CoeffTable = table (beta_full, se_full, tstat_full, pval_full, ...
        'VariableNames', {'Estimate', 'SE', 'tStat', 'pValue'}, ...
        'RowNames',      coef_names(:));

      ResidTable = table (Raw_full, Pearson_full, Stu_full, Std_full, ...
        'VariableNames', {'Raw', 'Pearson', 'Studentized', 'Standardized'});

      Lev_full = zeros (n_total, 1);
      CD_full  = NaN   (n_total, 1);
      Dff_full = NaN   (n_total, 1);
      S2i_full = NaN   (n_total, 1);
      CR_full  = NaN   (n_total, 1);
      Lev_full(subset_mask) = D.Leverage;
      CD_full(subset_mask)  = D.CooksDistance;
      Dff_full(subset_mask) = D.Dffits;
      S2i_full(subset_mask) = D.S2_i;
      CR_full(subset_mask)  = D.CovRatio;

      Dfb_full   = zeros (n_total, p);
      Dfb_full(subset_mask, :) = D.Dfbetas;

      HatMat_pad = zeros (n_total, n_obs);
      HatMat_pad(subset_mask, :) = D.HatMatrix;

      DiagTable = table (Lev_full, CD_full, Dff_full, S2i_full, CR_full, ...
        Dfb_full, HatMat_pad, ...
        'VariableNames', {'Leverage', 'CooksDistance', 'Dffits', 'S2_i', ...
                          'CovRatio', 'Dfbetas', 'HatMatrix'});

      if (has_intercept)
        non_int = coef_names(! strcmp (coef_names, '(Intercept)'));
        lp_str  = ifelse (isempty (non_int), '1', ['1 + ', strjoin(non_int, ' + ')]);
      else
        lp_str = strjoin (coef_names, ' + ');
      endif

      FormulaS.ResponseName    = resp_name;
      FormulaS.LinearPredictor = lp_str;
      FormulaS.PredictorNames  = pred_names_raw;
      FormulaS.TermNames       = coef_names;
      FormulaS.HasIntercept    = has_intercept;
      FormulaS.Terms           = terms;
      FormulaS.InModel         = true (1, n_coef);
      FormulaS.NTerms          = n_coef;
      FormulaS.NPredictors     = p_raw;
      FormulaS.NVars           = n_vars;

      ObsInfo = table (w_full, excluded_mask, missing_mask, subset_mask, ...
        'VariableNames', {'Weights', 'Excluded', 'Missing', 'Subset'});

      if (! istable (data))
        VarsTable = array2table ([X_raw, y_full], 'VariableNames', var_names_all);
      else
        VarsTable = tbl;
      endif

      nv_total   = numel (var_names_all);
      vi_class   = cell  (nv_total, 1);
      vi_range   = cell  (nv_total, 1);
      vi_inmodel = false (nv_total, 1);
      vi_iscat   = false (nv_total, 1);

      for j = 1:nv_total
        vname       = var_names_all{j};
        is_resp_var = strcmp (vname, resp_name);
        j_pred      = find (strcmp (pred_names_raw, vname), 1);

        if (! istable (data))
          if (! is_resp_var && ! isempty (j_pred))
            col_d = X_raw(:, j_pred);
            vi_iscat(j) = cat_logical(j_pred);
          else
            col_d = y_full;
          endif
          vi_class{j} = 'double';
          fv = col_d(isfinite (col_d));
          vi_range{j} = ifelse (isempty (fv), [NaN, NaN], [min(fv), max(fv)]);
        else
          col_d = tbl.(vname);
          vi_class{j} = class (col_d);
          if (isnumeric (col_d))
            fv = col_d(isfinite (col_d));
            vi_range{j} = ifelse (isempty (fv), [NaN, NaN], [min(fv), max(fv)]);
          elseif (iscell (col_d))
            vi_range{j} = unique (col_d);
          else
            vi_range{j} = {};
          endif
          if (! is_resp_var && ! isempty (j_pred))
            vi_iscat(j) = cat_logical(j_pred);
          endif
        endif

        if (! is_resp_var && ! isempty (j_pred))
          vi_inmodel(j) = true;
        endif
      endfor

      VarInfo = table (vi_class, vi_range, vi_inmodel, vi_iscat, ...
        'VariableNames', {'Class', 'Range', 'InModel', 'IsCategorical'}, ...
        'RowNames',      var_names_all(:));

      this.Coefficients             = CoeffTable;
      this.CoefficientCovariance    = fit.CovBeta;
      this.CoefficientNames         = coef_names;
      this.NumCoefficients          = n_coef;
      this.NumEstimatedCoefficients = p;
      this.DFE                      = DFE;
      this.Diagnostics              = DiagTable;
      this.Fitted                   = Fitted_full;
      this.LogLikelihood            = LogLikelihood;
      this.ModelCriterion           = struct ('AIC',  AIC, 'AICc', AICc, ...
                                             'BIC',  BIC, 'CAIC', CAIC);
      this.ModelFitVsNullModel      = struct ('Fstat',     Fstat, ...
                                             'Pvalue',    Fpval, ...
                                             'NullModel', 'constant');
      this.MSE                      = MSE;
      this.Residuals                = ResidTable;
      this.RMSE                     = RMSE;
      this.Rsquared                 = struct ('Ordinary', R2_ord, 'Adjusted', R2_adj);
      this.SSE                      = SSE;
      this.SSR                      = SSR;
      this.SST                      = SST;
      this.Robust                   = [];
      this.Steps                    = [];
      this.Formula                  = FormulaS;
      this.NumObservations          = n_obs;
      this.NumPredictors            = p_raw;
      this.NumVariables             = n_vars;
      this.ObservationInfo          = ObsInfo;
      this.ObservationNames         = {};
      this.PredictorNames           = pred_names_raw;
      this.ResponseName             = resp_name;
      this.VariableInfo             = VarInfo;
      this.VariableNames            = var_names_all;
      this.Variables                = VarsTable;

      this.DesignMatrix             = X_design_sub;
      this.ActiveCols               = fit.active_cols;
      this.HasIntercept             = has_intercept;
      this.ResponseVector           = y_full;
      this.WeightVector             = w_full;
      this.SubsetMask               = subset_mask;
      this.TermsMatrix              = terms;
      this.CatLevelInfo             = cat_info;
      this.EncPredictorNames        = enc_names;
      this.OrigOpts                 = opts;
      if (! is_formula)
        this.EncodedPredMatrix      = X_enc_sub;
      endif

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {LinearModel} {@var{ypred} =} predict (@var{mdl}, @var{Xnew})
    ## @deftypefnx {LinearModel} {@var{ypred} =} predict (@var{mdl})
    ## @deftypefnx {LinearModel} {[@var{ypred}, @var{yci}] =} predict (@var{mdl}, @var{Xnew})
    ## @deftypefnx {LinearModel} {[@var{ypred}, @var{yci}] =} predict (@var{mdl}, @var{Xnew}, @var{Name}, @var{Value})
    ##
    ## Predict responses of a fitted linear regression model.
    ##
    ## @code{@var{ypred} = predict (@var{mdl}, @var{Xnew})} returns predicted
    ## response values for the predictor data in @var{Xnew} using the fitted
    ## linear model @var{mdl}.  @var{Xnew} can be a numeric matrix or a table.
    ##
    ## @code{@var{ypred} = predict (@var{mdl})} returns predicted values for
    ## all observations in the training data, including excluded rows.
    ##
    ## @code{[@var{ypred}, @var{yci}] = predict (@dots{})} also returns
    ## confidence intervals @var{yci} as an @math{n} x @math{2} matrix.
    ##
    ## Name-Value pair arguments:
    ##
    ## @multitable @columnfractions 0.2 0.02 0.78
    ## @headitem @var{Name} @tab @tab @var{Value}
    ##
    ## @item @qcode{"Alpha"} @tab @tab Significance level, scalar in @math{[0,1]}.
    ## Default is @code{0.05}.
    ##
    ## @item @qcode{"Prediction"} @tab @tab @code{"curve"} (default) for
    ## confidence interval on the mean response, or @code{"observation"} for a
    ## prediction interval for a new observation.
    ##
    ## @item @qcode{"Simultaneous"} @tab @tab Logical flag.  If @code{true},
    ## compute simultaneous bounds using Scheff@'{e}'s method.  Default is
    ## @code{false}.
    ## @end multitable
    ##
    ## @seealso{fitlm, LinearModel}
    ## @end deftypefn
    function [ypred, yci] = predict (mdl, Xnew, varargin)

      alpha    = 0.05;
      pred_obs = false;
      simultan = false;

      i = 1;
      while (i <= numel (varargin))
        if (strcmpi (varargin{i}, 'Alpha'))
          alpha = varargin{i+1};
          if (! isscalar (alpha) || ! isnumeric (alpha) || alpha < 0 || alpha > 1)
            error ('predict: Alpha must be a scalar in [0,1].');
          endif
          i += 2;
        elseif (strcmpi (varargin{i}, 'Prediction'))
          pred_str = lower (char (varargin{i+1}));
          if (! any (strcmp (pred_str, {'curve', 'observation'})))
            error ('predict: Prediction must be ''curve'' or ''observation''.');
          endif
          pred_obs = strcmp (pred_str, 'observation');
          i += 2;
        elseif (strcmpi (varargin{i}, 'Simultaneous'))
          simultan = logical (varargin{i+1});
          i += 2;
        else
          error ('predict: unknown option ''%s''.', varargin{i});
        endif
      endwhile

      if (nargin < 2 || isempty (Xnew))
        Xnew = mdl.Variables;
      endif

      pred_names = mdl.PredictorNames;
      p_raw      = mdl.NumPredictors;

      if (istable (Xnew))
        n_new = height (Xnew);
        X_raw = zeros (n_new, p_raw);
        for j = 1:p_raw
          if (! ismember (pred_names{j}, Xnew.Properties.VariableNames))
            error ('predict: Xnew table is missing predictor ''%s''.', pred_names{j});
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
          error ('predict: Xnew must have %d columns.', p_raw);
        endif
        n_new = rows (X_raw);
      endif

      nan_rows     = any (isnan (X_raw), 2);
      X_enc_new    = LinearModel.lm_predict (X_raw, pred_names, mdl.CatLevelInfo);
      X_design_new = LinearModel.lm_build_design (mdl.TermsMatrix, X_enc_new);

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
    ## @deftypefn {LinearModel} {@var{ysim} =} random (@var{mdl}, @var{Xnew})
    ##
    ## Simulate responses with random noise for a fitted linear regression model.
    ##
    ## @code{@var{ysim} = random (@var{mdl}, @var{Xnew})} returns simulated
    ## response values for predictor data in @var{Xnew}.  Each simulated value
    ## equals the predicted response plus independent noise drawn from
    ## @math{N(0, @var{mdl}.MSE)}, where @code{MSE} is the mean squared error of
    ## the fitted model.
    ##
    ## @var{Xnew} must be a non-empty numeric matrix with the same number of
    ## columns as the training predictors, or a table with matching predictor
    ## column names.
    ##
    ## @seealso{fitlm, predict, LinearModel}
    ## @end deftypefn
    function ysim = random (mdl, Xnew, varargin)
      if (nargin < 2)
        error ('random: Not enough input arguments.');
      endif
      if (nargin > 2)
        error ('random: Too many input arguments.');
      endif
      if (isempty (Xnew))
        error ('random: Xnew must have %d columns.', mdl.NumPredictors);
      endif
      ypred = predict (mdl, Xnew);
      ysim  = ypred + sqrt (mdl.MSE) .* randn (numel (ypred), 1);
    endfunction

  endmethods

  methods (Access = private, Static)

    function opts = lm_parse_nv (nv_args)

      opt_names = {'Intercept', 'Weights', 'Exclude', 'RobustOpts', ...
                   'VarNames', 'CategoricalVars', 'ResponseVar', 'PredictorVars'};
      def_vals  = {true, [], [], [], {}, [], '', {}};
      [intercept, weights, exclude, robustopts, varnames, catvars, ...
       respvar, predvars, rem_args] = parsePairedArguments (opt_names, def_vals, nv_args);

      if (! isempty (rem_args))
        error ("LinearModel: Unknown option '%s'.", rem_args{1});
      endif
      
      opts.Intercept       = logical (intercept);
      opts.Exclude         = exclude;
      opts.RobustOpts      = robustopts;
      opts.CategoricalVars = catvars;
      opts.ResponseVar     = char (respvar);

      if (isempty (weights))
        opts.Weights = [];
      else
        opts.Weights = double (weights(:));
      endif

      if (isempty (varnames))
        opts.VarNames = {};
      else
        opts.VarNames = cellstr (varnames);
      endif

      if (isempty (predvars))
        opts.PredictorVars = {};
      else
        opts.PredictorVars = cellstr (predvars);
      endif
    endfunction

    ## Parse modelspec into terms matrix.
    function [terms, has_intercept, coef_names] = lm_parse_modelspec ( ...
        modelspec, pred_names, n_preds, intercept_nv)

      p = n_preds;

      if (isempty (modelspec) || (ischar (modelspec) && strcmpi (modelspec, 'linear')))
        terms = [zeros(1, p+1); [eye(p), zeros(p, 1)]];

      elseif (ischar (modelspec) && strcmpi (modelspec, 'constant'))
        terms = zeros (1, p+1);

      elseif (ischar (modelspec) && strcmpi (modelspec, 'interactions'))
        linear_part = [zeros(1, p+1); [eye(p), zeros(p, 1)]];
        inter_part  = zeros (0, p+1);
        for i = 1:p
          for j = i+1:p
            row = zeros (1, p+1); row(i) = 1; row(j) = 1;
            inter_part = [inter_part; row];
          endfor
        endfor
        terms = [linear_part; inter_part];

      elseif (ischar (modelspec) && strcmpi (modelspec, 'purequadratic'))
        linear_part = [zeros(1, p+1); [eye(p), zeros(p, 1)]];
        quad_part   = zeros (p, p+1);
        for j = 1:p
          quad_part(j, j) = 2;
        endfor
        terms = [linear_part; quad_part];

      elseif (ischar (modelspec) && strcmpi (modelspec, 'quadratic'))
        linear_part = [zeros(1, p+1); [eye(p), zeros(p, 1)]];
        quad_part   = zeros (p, p+1);
        for j = 1:p
          quad_part(j, j) = 2;
        endfor
        inter_part = zeros (0, p+1);
        for i = 1:p
          for j = i+1:p
            row = zeros (1, p+1); row(i) = 1; row(j) = 1;
            inter_part = [inter_part; row];
          endfor
        endfor
        terms = [linear_part; quad_part; inter_part];

      elseif (ischar (modelspec) && strcmpi (modelspec, 'full'))
        error ("fitlm: 'full' is not a valid model specification.");

      elseif (isnumeric (modelspec))
        terms = double (modelspec);
        if (size (terms, 2) == p)
          terms = [terms, zeros(rows (terms), 1)];
        elseif (size (terms, 2) == p + 1)
          if (! all (terms(:, end) == 0))
            error ('LinearModel: Last column of terms matrix must be all zeros.');
          endif
        else
          error ('LinearModel: Terms matrix must have %d or %d columns.', p, p+1);
        endif

      else
        error ('fitlm: Unknown model specification.');
      endif

      if (! intercept_nv)
        int_rows = all (terms(:, 1:end-1) == 0, 2);
        terms    = terms(! int_rows, :);
      endif

      has_intercept = any (all (terms(:, 1:end-1) == 0, 2));

      n_terms    = rows (terms);
      coef_names = cell (1, n_terms);
      for t = 1:n_terms
        term_row = terms(t, 1:end-1);
        if (all (term_row == 0))
          coef_names{t} = '(Intercept)';
        else
          parts_t = {};
          for j = 1:numel (term_row)
            if (term_row(j) != 0)
              if (term_row(j) == 1)
                parts_t{end+1} = pred_names{j};
              else
                parts_t{end+1} = sprintf ('%s^%d', pred_names{j}, term_row(j));
              endif
            endif
          endfor
          coef_names{t} = strjoin (parts_t, ':');
        endif
      endfor
    endfunction

    ## expand categorical columns into L-1 dummy variables
    function [X_enc, enc_names, cat_info] = lm_encode_categorical ( ...
        X_num, cat_cols, pred_names, cat_levels)

      X_enc     = zeros (rows (X_num), 0);
      enc_names = {};
      cat_info.names  = {};
      cat_info.levels = {};

      for j = 1:numel (pred_names)
        if (! cat_cols(j))
          X_enc     = [X_enc, X_num(:, j)];
          enc_names = [enc_names, pred_names{j}];
        else
          levels_j = cat_levels{j};
          if (isempty (levels_j))
            uvals    = sort (unique (X_num(isfinite (X_num(:,j)), j)));
            levels_j = cellstr (num2str (uvals(:)));
          endif
          n_lev = numel (levels_j);
          for L = 2:n_lev
            dummy     = double (X_num(:, j) == L);
            X_enc     = [X_enc, dummy];
            enc_names = [enc_names, [pred_names{j}, '_', char(levels_j{L})]];
          endfor
          cat_info.names{end+1}  = pred_names{j};
          cat_info.levels{end+1} = levels_j;
        endif
      endfor
    endfunction

    ## weighted least-squares via pivoted QR; returns fit struct
    function fit = lm_fit (X, y, w, compute_H)
      if (nargin < 4)
        compute_H = true;
      endif
      n = rows (X);
      p = columns (X);
      w = w(:);

      W_sqrt = sqrt (w);
      Xw     = X .* W_sqrt;
      yw     = y .* W_sqrt;

      [Q, R, Pperm] = qr (Xw, 0);

      if (isvector (Pperm))
        P_vec = double (Pperm(:)');
      else
        [~, P_vec] = max (Pperm, [], 1);
      endif

      dr = abs (diag (R));
      if (isempty (dr) || dr(1) == 0)
        rank_X = 0;
      else
        tol    = max (size (Xw)) * eps (dr(1));
        rank_X = sum (dr > tol);
      endif

      beta        = zeros (p, 1);
      active_cols = P_vec(1:rank_X);

      if (rank_X > 0)
        R11   = R(1:rank_X, 1:rank_X);
        Q1    = Q(:, 1:rank_X);
        gamma = R11 \ (Q1' * yw);
        beta(active_cols) = gamma;
      endif

      Fitted = X * beta;
      Raw    = y - Fitted;

      n_eff = sum (w > 0);
      SSE   = sum (w .* Raw.^2);
      wmean = sum (w .* y) / max (sum (w), eps);
      SST   = sum (w .* (y - wmean).^2);
      SSR   = SST - SSE;

      DFE = n_eff - rank_X;
      if (DFE > 0)
        MSE  = SSE / DFE;
        RMSE = sqrt (MSE);
      else
        MSE  = NaN;
        RMSE = NaN;
      endif

      CovBeta = zeros (p, p);
      if (rank_X > 0)
        R11_inv = R11 \ eye (rank_X);
        CovBeta(active_cols, active_cols) = MSE * (R11_inv * R11_inv');
      endif

      ## Compute hat matrix and leverage
      if (rank_X > 0)
        leverage = sum (Q1.^2, 2);
        if (compute_H)
          Q1t = Q1 * Q1';
          H   = (Q1t ./ W_sqrt) .* W_sqrt';
        else
          H = [];
        endif
      else
        leverage = zeros (n, 1);
        if (compute_H)
          H = zeros (n, n);
        else
          H = [];
        endif
      endif

      fit.beta        = beta;
      fit.H           = H;
      fit.leverage    = leverage;
      fit.SSE         = SSE;
      fit.SSR         = SSR;
      fit.SST         = SST;
      fit.DFE         = DFE;
      fit.MSE         = MSE;
      fit.RMSE        = RMSE;
      fit.CovBeta     = CovBeta;
      fit.rank_X      = rank_X;
      fit.active_cols = active_cols;
      fit.Fitted      = Fitted;
      fit.Raw         = Raw;
    endfunction

    ## observation-level influence statistics; returns D struct
    function D = lm_diagnostics (X, y, fit)
      n    = rows (X);
      p    = fit.rank_X;
      h    = fit.leverage;
      Raw  = fit.Raw;
      DFE  = fit.DFE;
      MSE  = fit.MSE;
      RMSE = fit.RMSE;

      S2_i = (DFE * MSE - Raw.^2 ./ max (1 - h, eps)) / max (DFE - 1, 1);

      r_std = Raw ./ max (RMSE .* sqrt (max (1 - h, eps)), eps);
      r_stu = Raw ./ max (sqrt (max (S2_i, eps)) .* sqrt (max (1 - h, eps)), eps);

      CooksDistance = (1 / max (p, 1)) .* r_std.^2 .* h ./ max (1 - h, eps);
      Dffits        = r_stu .* sqrt (h ./ max (1 - h, eps));
      CovRatio      = (S2_i ./ max (MSE, eps)).^p ./ max (1 - h, eps);

      active   = fit.active_cols;
      CovB_act = fit.CovBeta(active, active);
      XtXinv_d = diag (CovB_act) / max (MSE, eps);
      Dfbetas  = zeros (n, p);

      if (p > 0)
        for i = 1:n
          xi_act     = X(i, active)';
          infl       = (CovB_act / max (MSE, eps)) * xi_act;
          denom_base = (1 - h(i)) * sqrt (max (S2_i(i), eps));
          for jj = 1:p
            se_jj = sqrt (max (XtXinv_d(jj), eps));
            Dfbetas(i, jj) = infl(jj) * Raw(i) / max (denom_base * se_jj, eps);
          endfor
        endfor
      endif

      D.Leverage      = h;
      D.CooksDistance = CooksDistance;
      D.Dffits        = Dffits;
      D.S2_i          = S2_i;
      D.CovRatio      = CovRatio;
      D.Dfbetas       = Dfbetas;
      D.HatMatrix     = fit.H;
    endfunction

    function X_design = lm_build_design (terms, X_enc)
      n_obs    = rows (X_enc);
      n_coef   = rows (terms);
      p_enc    = columns (X_enc);
      X_design = zeros (n_obs, n_coef);
      for t = 1:n_coef
        term_row = terms(t, 1:p_enc);
        col_t    = ones (n_obs, 1);
        for j = find (term_row != 0)
          col_t = col_t .* (X_enc(:, j) .^ term_row(j));
        endfor
        X_design(:, t) = col_t;
      endfor
    endfunction

    function crit = lm_criteria (fit, n_obs, has_intercept)
      p   = fit.rank_X;
      SSE = fit.SSE;
      SSR = fit.SSR;
      SST = fit.SST;
      DFE = fit.DFE;
      MSE = fit.MSE;

      LogLikelihood = -(n_obs / 2) * (1 + log (2 * pi * SSE / n_obs));

      AIC  = -2 * LogLikelihood + 2 * p;
      dAIC = n_obs - p - 1;
      if (dAIC > 0)
        AICc = AIC + (2 * p * (p + 1)) / dAIC;
      else
        AICc = Inf;
      endif
      BIC  = -2 * LogLikelihood + p * log (n_obs);
      CAIC = BIC + p;

      R2_ord = SSR / max (SST, eps);
      if (n_obs > 1 && DFE > 0)
        R2_adj = 1 - (SSE / DFE) / (SST / (n_obs - 1));
      else
        R2_adj = NaN;
      endif

      if (has_intercept && p > 1)
        df1   = p - 1;
        Fstat = (SSR / df1) / max (MSE, eps);
        Fpval = 1 - fcdf (Fstat, df1, DFE);
      elseif (! has_intercept && p > 0)
        df1   = p;
        Fstat = (SSR / df1) / max (MSE, eps);
        Fpval = 1 - fcdf (Fstat, df1, DFE);
      else
        Fstat = NaN;
        Fpval = NaN;
      endif

      crit.LogLikelihood = LogLikelihood;
      crit.AIC           = AIC;
      crit.AICc          = AICc;
      crit.BIC           = BIC;
      crit.CAIC          = CAIC;
      crit.Rsquared      = R2_ord;
      crit.AdjRsquared   = R2_adj;
      crit.Fstat         = Fstat;
      crit.Fpval         = Fpval;
    endfunction

    function X_enc = lm_predict (X_raw, pred_names, cat_info)
      n     = rows (X_raw);
      X_enc = zeros (n, 0);
      for j = 1:numel (pred_names)
        cat_idx = [];
        if (! isempty (cat_info.names))
          cat_idx = find (strcmp (cat_info.names, pred_names{j}));
        endif
        if (isempty (cat_idx))
          X_enc = [X_enc, X_raw(:, j)];
        else
          levels_j = cat_info.levels{cat_idx};
          for L = 2:numel (levels_j)
            X_enc = [X_enc, double(X_raw(:, j) == L)];
          endfor
        endif
      endfor
    endfunction

    function mdl2 = lm_refit (mdl, new_terms)
      opts = mdl.OrigOpts;

      if (! isempty (mdl.CatLevelInfo) && isfield (mdl.CatLevelInfo, 'names') ...
          && ! isempty (mdl.CatLevelInfo.names))
        cat_vars = mdl.CatLevelInfo.names;
      else
        cat_vars = opts.CategoricalVars;
      endif

      nv_list = {'Intercept', opts.Intercept};
      if (! isempty (opts.Weights))
        nv_list = [nv_list, {'Weights', opts.Weights}];
      endif
      if (! isempty (opts.Exclude))
        nv_list = [nv_list, {'Exclude', opts.Exclude}];
      endif
      if (! isempty (cat_vars))
        nv_list = [nv_list, {'CategoricalVars', cat_vars}];
      endif

      mdl2 = fitlm (mdl.Variables, mdl.ResponseName, new_terms, nv_list{:});
    endfunction

  endmethods

endclassdef

%!shared mdl, X, y, n
%! n = 20;
%! X = [1:n; (1:n).^2]' / n;
%! y = X * [3; -1] + 0.2 * sin ((1:n)');
%! mdl = fitlm (X, y);

%!test
%! ## integer count properties
%! assert (mdl.NumObservations,          20);
%! assert (mdl.NumCoefficients,           3);
%! assert (mdl.NumVariables,              3);
%! assert (mdl.NumPredictors,             2);
%! assert (mdl.NumEstimatedCoefficients,  3);
%! assert (mdl.DFE,                      17);

%!test
%! ## SS partition identity and positivity
%! assert (mdl.SSE + mdl.SSR, mdl.SST, 1e-8);
%! assert (mdl.SSE / mdl.DFE, mdl.MSE, 1e-12);
%! assert (sqrt (mdl.MSE), mdl.RMSE, 1e-12);
%! assert (mdl.SSE > 0 && mdl.SSR > 0 && mdl.SST > 0);

%!test
%! ## constant model SSR zero SSE equals SST
%! mc = fitlm (X, y, 'constant');
%! assert (mc.SSR, 0, 1e-12);
%! assert (mc.SSE, mc.SST, 1e-12);

%!test
%! ## R-squared 
%! assert (mdl.Rsquared.Ordinary, 0.999338005765704, 1e-10);
%! assert (mdl.Rsquared.Adjusted, 0.999260124091081, 1e-10);
%! assert (mdl.Rsquared.Ordinary, mdl.SSR / mdl.SST, 1e-10);
%! assert (mdl.Rsquared.Adjusted, 1 - (mdl.SSE/mdl.DFE) / (mdl.SST/(n-1)), 1e-10);
%! assert (isfield (mdl.Rsquared, 'Ordinary') && isfield (mdl.Rsquared, 'Adjusted'));

%!test
%! ## residuals
%! assert (mdl.Residuals.Raw, y - mdl.Fitted, 1e-10);
%! assert (sum (mdl.Residuals.Raw), 0, 1e-8);
%! assert (mdl.Residuals.Pearson, mdl.Residuals.Raw / sqrt (mdl.MSE), 1e-10);

%!test
%! ## standardized and studentized residual formulas
%! h   = mdl.Diagnostics.Leverage;
%! S2i = mdl.Diagnostics.S2_i;
%! assert (mdl.Residuals.Standardized, ...
%!         mdl.Residuals.Raw ./ (mdl.RMSE .* sqrt (1 - h)), 1e-8);
%! assert (mdl.Residuals.Studentized, ...
%!         mdl.Residuals.Raw ./ (sqrt (S2i) .* sqrt (1 - h)), 1e-6);

%!test
%! ## fitted values equal y minus raw residuals
%! assert (numel (mdl.Fitted), 20);
%! assert (all (! isnan (mdl.Fitted)));
%! assert (mdl.Fitted, y - mdl.Residuals.Raw, 1e-10);
%! yp = predict (mdl, X);
%! assert (size (yp), [20, 1]);
%! assert (class (yp), 'double');
%! assert (yp(1), 0.192669485827491, 1e-10);
%! assert (yp(2), 0.171266760882256, 1e-10);

%!test
%! ## coefficient estimates SE tStat 
%! assert (mdl.Coefficients.Estimate, [0.1161886778; 2.508451491; -0.9788353298], 1e-7);
%! assert (mdl.Coefficients.SE,       [0.112185831;  0.4920818186; 0.02276108523], 1e-8);
%! assert (mdl.Coefficients.tStat,    [1.035680502;  5.097630913; -43.00477415],   1e-6);

%!test
%! ## tStat and pValue
%! assert (mdl.Coefficients.tStat, ...
%!         mdl.Coefficients.Estimate ./ mdl.Coefficients.SE, 1e-10);
%! assert (all (mdl.Coefficients.SE > 0));
%! assert (all (mdl.Coefficients.pValue >= 0 & mdl.Coefficients.pValue <= 1));

%!test
%! ## CoefficientNames matches Coefficients row names
%! assert (isequal (mdl.CoefficientNames, mdl.Coefficients.Properties.RowNames(:)'));
%! assert (mdl.CoefficientNames{1}, '(Intercept)');
%! assert (mdl.CoefficientNames{2}, 'x1');
%! assert (mdl.CoefficientNames{3}, 'x2');

%!test
%! ## CoefficientCovariance properties
%! assert (size (mdl.CoefficientCovariance), [3, 3]);
%! assert (mdl.CoefficientCovariance, mdl.CoefficientCovariance', 1e-12);
%! assert (diag (mdl.CoefficientCovariance), [0.0125857; 0.242145; 0.000518067], 1e-6);
%! assert (all (diag (mdl.CoefficientCovariance) >= 0));
%! assert (mdl.Coefficients.SE, sqrt (diag (mdl.CoefficientCovariance)), 1e-10);

%!test
%! ## HatMatrix properties
%! H = mdl.Diagnostics.HatMatrix;
%! assert (size (H), [20, 20]);
%! assert (mdl.Diagnostics.Leverage, diag (H), 1e-10);
%! assert (sum (mdl.Diagnostics.Leverage), 3, 1e-8);
%! assert (H, H', 1e-10);
%! assert (H * H, H, 1e-8);
%! assert (all (mdl.Diagnostics.Leverage >= 0) && all (mdl.Diagnostics.Leverage <= 1));

%!test
%! ## Cook's D S2_i CovRatio Dffits formulas
%! p   = mdl.NumEstimatedCoefficients;
%! h   = mdl.Diagnostics.Leverage;
%! raw = mdl.Residuals.Raw;
%! r   = mdl.Residuals.Standardized;
%! S2i = mdl.Diagnostics.S2_i;
%! assert (mdl.Diagnostics.CooksDistance, (1/p) .* r.^2 .* h ./ (1-h), 1e-8);
%! assert (mdl.Diagnostics.S2_i, (mdl.DFE*mdl.MSE - raw.^2./(1-h))/(mdl.DFE-1), 1e-8);
%! assert (mdl.Diagnostics.CovRatio, (S2i./mdl.MSE).^p ./ (1-h), 1e-6);
%! assert (mdl.Diagnostics.Dffits, mdl.Residuals.Studentized .* sqrt(h./(1-h)), 1e-6);
%! assert (all (mdl.Diagnostics.CooksDistance >= 0));

%!test
%! ## Dfbetas size
%! assert (size (mdl.Diagnostics.Dfbetas), [20, 3]);

%!test
%! ## Diagnostics table schema
%! assert (width (mdl.Diagnostics), 7);
%! assert (isequal (mdl.Diagnostics.Properties.VariableNames, ...
%!                  {'Leverage','CooksDistance','Dffits','S2_i', ...
%!                   'CovRatio','Dfbetas','HatMatrix'}));

%!test
%! ## LogLikelihood formula
%! assert (mdl.LogLikelihood, 11.0836133807695, 1e-6);
%! assert (mdl.LogLikelihood, -(n/2)*(1 + log(2*pi*mdl.SSE/n)), 1e-8);

%!test
%! ## Information criteria
%! assert (mdl.ModelCriterion.AIC,  -16.1672267615389, 1e-6);
%! assert (mdl.ModelCriterion.AICc, -14.6672267615389, 1e-6);
%! assert (mdl.ModelCriterion.BIC,  -13.180029940877,  1e-6);
%! assert (mdl.ModelCriterion.CAIC, -10.180029940877,  1e-6);
%! assert (mdl.ModelCriterion.BIC > mdl.ModelCriterion.AIC);
%! assert (isfield (mdl.ModelCriterion, 'AIC')  && isfield (mdl.ModelCriterion, 'AICc') && ...
%!         isfield (mdl.ModelCriterion, 'BIC')  && isfield (mdl.ModelCriterion, 'CAIC'));

%!test
%! ## Model fit vs null model
%! assert (mdl.ModelFitVsNullModel.Fstat, 12831.4909842738, 1e-4);
%! assert (mdl.ModelFitVsNullModel.Pvalue >= 0 && mdl.ModelFitVsNullModel.Pvalue <= 1);
%! assert (strcmp (mdl.ModelFitVsNullModel.NullModel, 'constant'));
%! p2  = mdl.NumEstimatedCoefficients - 1;
%! R2  = mdl.Rsquared.Ordinary;
%! assert (mdl.ModelFitVsNullModel.Fstat, (R2/p2)/((1-R2)/(n-p2-1)), 1e-6);

%!test
%! ## Coefficients table schema
%! assert (width (mdl.Coefficients), 4);
%! assert (height (mdl.Coefficients), 3);
%! assert (isequal (mdl.Coefficients.Properties.VariableNames, ...
%!                  {'Estimate','SE','tStat','pValue'}));

%!test
%! ## Residuals table schema
%! assert (width (mdl.Residuals), 4);
%! assert (height (mdl.Residuals), 20);
%! assert (isequal (mdl.Residuals.Properties.VariableNames, ...
%!                  {'Raw','Pearson','Studentized','Standardized'}));
%! assert (all (! isnan (mdl.Residuals.Raw)));

%!test
%! ## ObservationInfo schema
%! assert (width (mdl.ObservationInfo), 4);
%! assert (height (mdl.ObservationInfo), 20);
%! assert (isequal (mdl.ObservationInfo.Properties.VariableNames, ...
%!                  {'Weights','Excluded','Missing','Subset'}));
%! assert (all (mdl.ObservationInfo.Weights == 1));
%! assert (sum (mdl.ObservationInfo.Subset), 20);
%! assert (all (mdl.ObservationInfo.Subset == ...
%!              (! mdl.ObservationInfo.Missing & ! mdl.ObservationInfo.Excluded)));

%!test
%! ## VariableInfo schema
%! assert (width  (mdl.VariableInfo), 4);
%! assert (height (mdl.VariableInfo), 3);
%! assert (isequal (mdl.VariableInfo.Properties.VariableNames, ...
%!                  {'Class','Range','InModel','IsCategorical'}));
%! assert (mdl.VariableInfo.InModel(strcmp (mdl.VariableNames, 'y')), false);
%! assert (all (mdl.VariableInfo.InModel(! strcmp (mdl.VariableNames, 'y'))));
%! assert (ischar (mdl.VariableInfo.Class{1}));

%!test
%! ## Predictor and variable names
%! assert (mdl.ResponseName, 'y');
%! assert (isequal (mdl.PredictorNames, {'x1','x2'}));
%! assert (isequal (mdl.VariableNames, {'x1','x2','y'}));

%!test
%! ## Formula struct properties
%! assert (mdl.Formula.HasIntercept, true);
%! assert (mdl.Formula.LinearPredictor, '1 + x1 + x2');
%! assert (mdl.Formula.NTerms, 3);
%! assert (isfield (mdl.Formula, 'ResponseName') && isfield (mdl.Formula, 'LinearPredictor'));

%!test
%! ## Variables table schema
%! assert (strcmp (mdl.Variables.Properties.VariableNames{end}, 'y'));

%!test
%! ## NaN in predictor
%! X2 = X;  X2(2,1) = NaN;
%! m2 = fitlm (X2, y);
%! assert (m2.NumObservations, 19);
%! assert (m2.ObservationInfo.Missing(2), true);
%! assert (m2.ObservationInfo.Subset(2),  false);
%! assert (isnan (m2.Fitted(2)));
%! assert (m2.SST, 547.6167961780454, 1e-8);
%! yp2 = predict (m2, X2);
%! assert (isnan (yp2(2)));
%! assert (! isnan (yp2(1)));

%!test
%! ## NaN in response
%! y3 = y;  y3(5) = NaN;
%! m3 = fitlm (X, y3);
%! assert (m3.NumObservations, 19);
%! assert (m3.ObservationInfo.Missing(5), true);
%! assert (isnan (m3.Fitted(5)));

%!test
%! ## multiple NaN rows
%! X4 = X;  X4([2,8,14],2) = NaN;
%! m4 = fitlm (X4, y);
%! assert (sum (m4.ObservationInfo.Missing), 3);
%! assert (m4.NumObservations, 17);
%! assert (m4.SSE + m4.SSR, m4.SST, 1e-8);

%!test
%! ## exclude by index
%! me = fitlm (X, y, 'Exclude', [3, 7]);
%! assert (me.NumObservations, 18);
%! assert (sum (me.ObservationInfo.Excluded), 2);
%! assert (isnan (me.Fitted(3)) && isnan (me.Fitted(7)));
%! ype = predict (me);
%! assert (size (ype), [20, 1]);
%! assert (! isnan (ype(3)));
%! assert (! isnan (ype(7)));
%! [~, yci] = predict (me);
%! assert (yci(1,1), -0.028312276245845, 1e-10);
%! assert (yci(1,2),  0.412312049343719, 1e-10);

%!test
%! ## exclude by logical vector
%! excl = false (n, 1);  excl([1, 4]) = true;
%! me2 = fitlm (X, y, 'Exclude', excl);
%! assert (me2.NumObservations, 18);
%! assert (me2.ObservationInfo.Excluded(1) && me2.ObservationInfo.Excluded(4));

%!test
%! ## NaN and exclude
%! X6 = X;  X6(1,1) = NaN;
%! m6 = fitlm (X6, y, 'Exclude', [2]);
%! assert (m6.NumObservations, 18);
%! assert (m6.ObservationInfo.Missing(1),  true);
%! assert (m6.ObservationInfo.Excluded(2), true);

%!test
%! ## WLS SSE
%! w  = abs (sin ((1:n)')) + 0.1;
%! mw = fitlm (X, y, 'Weights', w);
%! assert (mw.SSE,    0.363519720897775, 1e-10);
%! assert (mw.ObservationInfo.Weights, w, 1e-15);
%! assert (mw.SST, 4.419834786423099e+02, 1e-8);
%! ypw = predict (mw, X);
%! assert (size (ypw), [20, 1]);
%! assert (class (ypw), 'double');
%! [ypw2, yci] = predict (mw, [0.5 0.25; 1.0 1.0]);
%! assert (ypw2(1),  1.106748776307639, 1e-10);
%! assert (ypw2(2),  1.593185531572655, 1e-10);
%! assert (yci(1,1), 0.763985050242272, 1e-10);
%! assert (yci(1,2), 1.449512502373006, 1e-10);

%!test
%! ## uniform weights
%! mw2 = fitlm (X, y, 'Weights', 2 * ones (n, 1));
%! assert (mw2.Coefficients.Estimate, mdl.Coefficients.Estimate, 1e-10);

%!test
%! ## constant and linear modelspecs
%! mc = fitlm (X, y, 'constant');
%! assert (mc.NumCoefficients, 1);
%! assert (mc.CoefficientNames{1}, '(Intercept)');
%! ml = fitlm (X, y, 'linear');
%! m0 = fitlm (X, y, []);
%! assert (ml.NumCoefficients, 3);
%! assert (ml.Coefficients.Estimate, mdl.Coefficients.Estimate, 1e-12);
%! assert (m0.Coefficients.Estimate, mdl.Coefficients.Estimate, 1e-12);

%!test
%! ## modelspec term counts
%! assert (fitlm (X, y, 'interactions').NumCoefficients,  4);
%! assert (fitlm (X, y, 'purequadratic').NumCoefficients, 5);
%! assert (fitlm (X, y, 'quadratic').NumCoefficients,     6);

%!test
%! ## SS partition holds
%! for s = {'constant','linear','interactions','purequadratic','quadratic'}
%!   ms = fitlm (X, y, s{1});
%!   assert (ms.SSE + ms.SSR, ms.SST, 1e-8);
%! endfor

%!test
%! ## Intercept=false
%! mni = fitlm (X, y, 'Intercept', false);
%! assert (mni.NumCoefficients, 2);
%! assert (mni.Formula.HasIntercept, false);
%! assert (! any (strcmp (mni.CoefficientNames, '(Intercept)')));
%! [yp, yci] = predict (mni, [0.5 0.25; 1.0 1.0]);
%! assert (yp(1), 1.231398619227234, 1e-10);
%! assert (yp(2), 1.964172863732825, 1e-10);
%! assert (yci(1,1), 1.001262470857215, 1e-10);

%!test
%! ## p-column terms matrix
%! m_p = fitlm (X, y, [1 0; 0 1]);
%! assert (m_p.NumCoefficients, 2);
%! assert (! any (strcmp (m_p.CoefficientNames, '(Intercept)')));

%!test
%! ## p+1 column terms matrix
%! m_p1 = fitlm (X, y, [0 0 0; 1 0 0; 0 1 0]);
%! assert (m_p1.NumCoefficients, 3);
%! assert (m_p1.CoefficientNames{1}, '(Intercept)');

%!test
%! ## table Wilkinson formula
%! T = table (X(:,1), X(:,2), y, 'VariableNames', {'a','b','resp'});
%! mf = fitlm (T, 'resp ~ a + b');
%! assert (mf.NumCoefficients, 3);
%! assert (mf.ResponseName, 'resp');
%! assert (mf.Coefficients.Estimate, mdl.Coefficients.Estimate, 1e-8);
%! Xt = table ([0.5;1.0], [0.25;1.0], 'VariableNames', {'a','b'});
%! yp = predict (mf, Xt);
%! assert (yp(1), 1.125705590619342, 1e-10);
%! assert (yp(2), 1.645804838535884, 1e-10);

%!test
%! ## matrix Wilkinson formula
%! mfm = fitlm (X, y, 'y ~ x1 + x2');
%! assert (mfm.NumCoefficients, 3);
%! assert (mfm.Coefficients.Estimate, mdl.Coefficients.Estimate, 1e-8);

%!test
%! ## table default
%! T3 = table (X(:,1), X(:,2), y, 'VariableNames', {'x1','x2','y'});
%! mt = fitlm (T3);
%! assert (mt.ResponseName, 'y');
%! assert (mt.Coefficients.Estimate, mdl.Coefficients.Estimate, 1e-8);

%!test
%! ## VarNames sets custom names
%! vn = fitlm (X, y, 'VarNames', {'alpha','beta','resp'});
%! assert (vn.ResponseName, 'resp');
%! assert (isequal (vn.PredictorNames, {'alpha','beta'}));
%! assert (any (strcmp (vn.CoefficientNames, 'alpha')));
%! assert (any (strcmp (vn.CoefficientNames, 'beta')));

%!test
%! ## ResponseVar overrides VarNames
%! rv = fitlm (X, y, 'VarNames', {'a','b','r'}, 'ResponseVar', 'r');
%! assert (rv.ResponseName, 'r');

%!test
%! ## rank-deficient matrix
%! X_rd = [ones(n,1), X, X(:,1)+X(:,2)];
%! m_rd = fitlm (X_rd, y);
%! assert (m_rd.NumCoefficients, 5);
%! assert (m_rd.NumEstimatedCoefficients, 3);
%! drop = find (m_rd.Coefficients.SE == 0);
%! assert (numel (drop), 2);
%! assert (all (isnan (m_rd.Coefficients.tStat(drop))));
%! assert (all (isnan (m_rd.Coefficients.pValue(drop))));
%! assert (m_rd.SST, 5.839104200023459e+02, 1e-8);
%! assert (all (all (m_rd.CoefficientCovariance(drop,:) == 0)));
%! yp = predict (m_rd, X_rd);
%! assert (size (yp), [n, 1]);
%! assert (! any (isnan (yp)));

%!test
%! ## predict: ypred and default CI at new points
%! [yp, yci] = predict (mdl, [0.5 0.25; 1.0 1.0]);
%! assert (yp(1),    1.125705590619347, 1e-10);
%! assert (yp(2),    1.645804838535894, 1e-10);
%! assert (yci(1,1), 0.810180780547215, 1e-10);
%! assert (yci(1,2), 1.441230400691478, 1e-10);
%! assert (yci(2,1), 0.858229321851723, 1e-10);
%! assert (yci(2,2), 2.433380355220066, 1e-10);

%!test
%! ## predict: observation interval
%! [~, yci] = predict (mdl, [0.5 0.25; 1.0 1.0], 'Prediction', 'observation');
%! assert (yci(1,1), 0.677632064105988, 1e-10);
%! assert (yci(1,2), 1.573779117132706, 1e-10);

%!test
%! ## predict: alpha 0.01
%! [~, yci] = predict (mdl, [0.5 0.25; 1.0 1.0], 'Alpha', 0.01);
%! assert (yci(1,1), 0.692272619570008, 1e-10);
%! assert (yci(1,2), 1.559138561668685, 1e-10);

%!test
%! ## predict: simultaneous CI
%! [~, yci] = predict (mdl, [0.5 0.25; 1.0 1.0], 'Simultaneous', true);
%! assert (yci(1,1), 0.662572505689338, 1e-10);
%! assert (yci(1,2), 1.588838675549355, 1e-10);

%!test
%! ## predict: no Xnew returns all rows including training
%! [yp, yci] = predict (mdl);
%! assert (size (yp),  [20, 1]);
%! assert (size (yci), [20, 2]);
%! assert (yp(1),    0.192669485827490, 1e-10);
%! assert (yp(2),    0.171266760882255, 1e-10);
%! assert (yci(1,1), -0.001052067982566, 1e-10);
%! assert (yci(1,2),  0.386391039637546, 1e-10);

%!test
%! ## predict: NaN predictor propagates to NaN output and CI
%! [yp, yci] = predict (mdl, [0.5 0.25; NaN 1.0; 1.0 1.0]);
%! assert (yp(1), 1.125705590619347, 1e-10);
%! assert (isnan (yp(2)));
%! assert (yp(3), 1.645804838535894, 1e-10);
%! assert (isnan (yci(2,1)));
%! assert (isnan (yci(2,2)));

%!test
%! ## predict: categorical model predictions at group centres
%! Xc    = [1;1;1;2;2;2;3;3;3];
%! yc    = [2.1;2.3;1.9; 4.1;3.9;4.2; 6.3;5.8;6.1];
%! m_cat = fitlm (Xc, yc, 'linear', 'CategoricalVars', 1);
%! [yp, yci] = predict (m_cat, [1;2;3]);
%! assert (yp(1), 2.099999999999998, 1e-10);
%! assert (yp(2), 4.066666666666667, 1e-10);
%! assert (yp(3), 6.066666666666666, 1e-10);
%! assert (yci(1,1), 1.809712563216691, 1e-10);
%! assert (yci(1,2), 2.390287436783305, 1e-10);

%!test
%! ## predict: interaction model
%! [yp, yci] = predict (fitlm (X, y, 'interactions'), [0.5 0.25; 1.0 1.0]);
%! assert (yp(1),    0.964032452046850, 1e-10);
%! assert (yp(2),    1.282176811827644, 1e-10);
%! assert (yci(1,1), -0.110763003580605, 1e-10);
%! assert (yci(1,2),  2.038827907674306, 1e-10);

%!test
%! ## output is 2x1 double column vector
%! ysim = random (mdl, [0.5, 0.25; 1.0, 1.0]);
%! assert (size (ysim), [2, 1]);
%! assert (class (ysim), 'double');
%! assert (iscolumn (ysim));

%!test
%! ## single row input gives 1x1 output
%! assert (size (random (mdl, [0.5, 0.25])), [1, 1]);

%!test
%! ## predict values are exact and noise added is finite
%! ypred = predict (mdl, [0.5, 0.25; 1.0, 1.0]);
%! ysim  = random (mdl, [0.5, 0.25; 1.0, 1.0]);
%! assert (ypred(1), 1.125705590619342, 1e-10);
%! assert (ypred(2), 1.645804838535884, 1e-10);
%! assert (all (isfinite (ysim - ypred)));

%!test
%! ## NaN predictor row gives NaN output, other rows stay finite
%! ysim = random (mdl, [0.5, 0.25; NaN, 1.0; 1.0, 1.0]);
%! assert (size (ysim), [3, 1]);
%! assert (isfinite (ysim(1)));
%! assert (isnan (ysim(2)));
%! assert (isfinite (ysim(3)));

%!test
%! ## two sequential calls produce different output
%! ya = random (mdl, [0.5, 0.25]);
%! yb = random (mdl, [0.5, 0.25]);
%! assert (! isequal (ya, yb));

%!test
%! ## table input gives same size and finite output as matrix
%! Xt   = table ([0.5;1.0], [0.25;1.0], 'VariableNames', {'x1','x2'});
%! ysim = random (mdl, Xt);
%! assert (size (ysim), [2, 1]);
%! assert (all (isfinite (ysim)));

%!test
%! ## full training data gives 20 row output with no NaN
%! ysim = random (mdl, X);
%! assert (size (ysim), [20, 1]);
%! assert (sum (isnan (ysim)), 0);

%!test
%! ## weighted model gives correct size output
%! w    = (1:n)' / sum (1:n);
%! mw   = fitlm (X, y, 'Weights', w);
%! ysim = random (mw, [0.5, 0.25; 1.0, 1.0]);
%! assert (size (ysim), [2, 1]);
%! assert (all (isfinite (ysim)));

%!test
%! ## no intercept model gives correct size output
%! mni  = fitlm (X, y, 'Intercept', false);
%! ysim = random (mni, [0.5, 0.25; 1.0, 1.0]);
%! assert (size (ysim), [2, 1]);
%! assert (all (isfinite (ysim)));

%!error <'full' is not a valid model specification> fitlm (X, y, 'full')
%!error <Unknown option 'NotAKey'> fitlm (X, y, 'NotAKey', 1)
%!error <VarNames must have 3 elements> fitlm (X, y, 'VarNames', {'a','b','c','d'})
%!error <Terms matrix must have 2 or 3 columns> fitlm (X, y, [1 2 3 4; 5 6 7 8])
%!error <Last column of terms matrix must be all zeros> fitlm (X, y, [1 2 1; 0 1 1])
%!error <No observations remain> fitlm (NaN (5, 2), NaN (5, 1))
%!error <No observations remain> fitlm (NaN (3, 2), [1; 2; 3])
%!error <No observations remain> fitlm ([1 2; 3 4; 5 6], NaN (3, 1))
%!error <No observations remain> fitlm (X, y, 'Exclude', (1:n)')
%!error <Not enough input arguments> fitlm ()
%!error <Predictor variables must be numeric> fitlm ('hello', y)
%!error <Predictor variables must be numeric> fitlm ({'a';'b'}, [1; 2])
%!error <Y argument is required> fitlm (X)
%!error <Y argument is required> fitlm (X, 'Weights', [1;1;1])
%!error <Predictor and response variables must have the same length> fitlm (X, [1; 2])
%!error <Predictor and response variables must have the same length> fitlm (X, [1 2])
%!error <indexing is not supported> mdl (1)
%!error <indexing is not supported> mdl {1}
%!error <unknown option> predict (mdl, [0.5 0.25], 'BadOption', 1)
%!error <Alpha must be a scalar> predict (mdl, [0.5 0.25], 'Alpha', -0.1)
%!error <Alpha must be a scalar> predict (mdl, [0.5 0.25], 'Alpha', 1.5)
%!error <Alpha must be a scalar> predict (mdl, [0.5 0.25], 'Alpha', [0.01 0.05])
%!error <Prediction must be> predict (mdl, [0.5 0.25], 'Prediction', 'bad')
%!error <Xnew must have 2 columns> predict (mdl, ones (3, 5))
%!error <Xnew must have 2 columns> predict (mdl, ones (3, 1))
%!error <missing predictor> predict (mdl, table ([1;2], 'VariableNames', {'z'}))
%!error <Not enough input arguments> random (mdl)
%!error <Too many input arguments> random (mdl, [0.5, 0.25], 'extra')
%!error <Xnew must have 2 columns> random (mdl, ones (3, 5))
%!error <Xnew must have 2 columns> random (mdl, [])

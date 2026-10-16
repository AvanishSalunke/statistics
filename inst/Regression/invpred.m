## Copyright (C) 2026 Andreas Bertsatos <abertsatos@biol.uoa.gr>
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
## FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
## more details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn  {statistics} {@var{x0} =} invpred (@var{x}, @var{y}, @var{y0})
## @deftypefnx {statistics} {[@var{x0}, @var{dxlo}, @var{dxup}] =} invpred (@var{x}, @var{y}, @var{y0})
## @deftypefnx {statistics} {[@dots{}] =} invpred (@dots{}, @var{name}, @var{value})
##
## Inverse prediction from a simple linear regression.
##
## @code{@var{x0} = invpred (@var{x}, @var{y}, @var{y0})} fits the simple
## linear regression of @var{y} on @var{x} and returns, for each element of
## @var{y0}, the value of the predictor at which the fitted line takes that
## response.  @var{x} and @var{y} must be vectors of real values of the same
## length; @var{y0} may be of any size and @var{x0} is returned with the same
## size.  Observations where either @var{x} or @var{y} is @code{NaN} are
## dropped in pairs before the fit.
##
## @code{[@var{x0}, @var{dxlo}, @var{dxup}] = invpred (@dots{})} also returns
## the width of a confidence interval on either side of @var{x0}, so that the
## interval is @code{[@var{x0} - @var{dxlo}, @var{x0} + @var{dxup}]}.  The
## bounds follow Fieller's theorem and are therefore not symmetric about
## @var{x0}.  They are not simultaneous over the elements of @var{y0}, and
## they need not be finite: when the slope is not significantly different
## from zero at the requested level, the interval either covers the entire
## real line, with @var{dxlo} and @var{dxup} both @code{Inf}, or it excludes
## a finite range around the fitted line and extends to @code{Inf} on one
## side only, with the other side of @var{dxlo}/@var{dxup} finite.
##
## The bounds are @code{NaN} when only two observations remain after missing
## values are dropped, since the fit then has no residual degrees of freedom,
## and for elements of @var{y0} that are @code{NaN}.
##
## @code{[@dots{}] = invpred (@dots{}, @var{name}, @var{value})} accepts the
## following name-value pairs:
##
## @itemize
## @item
## @qcode{"alpha"} is the significance level of the interval, a scalar
## strictly between 0 and 1, so that the interval has confidence
## @math{100 * (1 - @var{alpha})%}.  The default is @qcode{0.05}.
##
## @item
## @qcode{"predopt"} selects what the interval covers.  With
## @qcode{"observation"}, the default, it covers a new observation whose
## response is @var{y0}.  With @qcode{"curve"}, it covers the point at which
## the true regression line takes the value @var{y0}, and is narrower because
## it carries no new-observation variance.
## @end itemize
##
## @seealso{regress, fitlm, polyfit}
## @end deftypefn

function [x0, dxlo, dxup] = invpred (x, y, y0, varargin)

  ## Check for valid number of input arguments
  if (nargin < 3)
    print_usage ();
  endif

  if (! (isvector (x) && isnumeric (x) && isreal (x)))
    error ("invpred: X must be a vector of real values.");
  endif
  if (! (isvector (y) && isnumeric (y) && isreal (y)))
    error ("invpred: Y must be a vector of real values.");
  endif
  if (numel (x) != numel (y))
    error ("invpred: X and Y must have the same length.");
  endif
  if (! (isnumeric (y0) && isreal (y0)))
    error ("invpred: Y0 must be numeric and real.");
  endif

  ## Parse optional name-value pairs
  alpha = 0.05;
  predopt = "observation";
  if (mod (numel (varargin), 2) != 0)
    error ("invpred: optional arguments must be name-value pairs.");
  endif
  for i = 1:2:numel (varargin)
    name = varargin{i};
    value = varargin{i+1};
    if (! (ischar (name) && isrow (name)))
      error ("invpred: parameter name must be a character vector.");
    endif
    switch (lower (name))
      case 'alpha'
        alpha = value;
      case 'predopt'
        predopt = value;
      otherwise
        error ("invpred: invalid parameter name: %s.", name);
    endswitch
  endfor
  if (! (isnumeric (alpha) && isreal (alpha) && isscalar (alpha) ...
         && alpha > 0 && alpha < 1))
    error ("invpred: ALPHA must be a scalar strictly between 0 and 1.");
  endif
  if (! (ischar (predopt) && isrow (predopt)) ...
      || ! any (strcmpi (predopt, {"curve", "observation"})))
    error ("invpred: PREDOPT value must be 'curve' or 'observation'.");
  endif

  ## Drop observations that are missing in either variable
  x = x(:);
  y = y(:);
  keep = ! (isnan (x) | isnan (y));
  x = x(keep);
  y = y(keep);
  n = numel (x);

  xbar = mean (x);
  ybar = mean (y);
  sxx = sum ((x - xbar) .^ 2);
  if (sxx == 0)
    error ("invpred: cannot compute inverse predictions if X is constant.");
  endif

  ## Fit the line and take the residual variance about it
  slope = sum ((x - xbar) .* (y - ybar)) / sxx;
  s2 = sum ((y - (ybar + slope * (x - xbar))) .^ 2) / (n - 2);

  ## The point estimate simply inverts the fitted line
  offset = (y0 - ybar) / slope;
  x0 = xbar + offset;

  if (nargout < 2)
    return;
  endif

  if (n < 3)
    dxlo = NaN (size (y0));
    dxup = NaN (size (y0));
    return;
  endif

  ## Fieller's interval: x is accepted where the fitted deviation
  ## z = slope * (x - xbar) satisfies a * z^2 + b * z + c <= 0
  t_crit = tinv (1 - alpha / 2, n - 2);
  k = t_crit ^ 2 * s2;

  ## A new observation carries its own variance; a point on the curve does not
  extra = double (strcmpi (predopt, "observation"));
  d = y0(:) - ybar;
  a = 1 - k / (slope ^ 2 * sxx);
  b = 2 * (ybar - y0(:));
  c = d .^ 2 - k * (1 / n + extra);

  disc = b .^ 2 - 4 * a * c;
  noroots = (disc < 0) & (b != 0);
  disc(disc < 0) = 0;
  q = -(b + sign (b) .* sqrt (disc)) / 2;
  z = [q / a, c ./ q];

  if (a > 0)
    zlo = min (z, [], 2);
    zhi = max (z, [], 2);
    zlo(noroots) = NaN;
    zhi(noroots) = NaN;
  else
    ## The accepted set is two outer rays; keep the one that contains x0
    below = z <= d;
    zlo = z;
    zlo(! below) = -Inf;
    zlo = max (zlo, [], 2);
    zhi = z;
    zhi(below) = Inf;
    zhi = min (zhi, [], 2);
    zlo(noroots) = -Inf;
    zhi(noroots) = Inf;
  endif

  if (slope > 0)
    dxlo = (d - zlo) / slope;
    dxup = (zhi - d) / slope;
  else
    dxlo = (d - zhi) / slope;
    dxup = (zlo - d) / slope;
  endif
  dxlo = reshape (dxlo, size (y0));
  dxup = reshape (dxup, size (y0));

endfunction

%!demo
%! ## Estimate the predictor value at which a fitted line reaches a response
%! ## of 20, with a 95% confidence interval either side of it.
%!
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! [x0, dxlo, dxup] = invpred (x, y, 20)
%! interval = [x0 - dxlo, x0 + dxup]

## The point estimate inverts the fitted line.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! x0 = invpred (x, y, 20);
%! assert_equal (x0, 5.964741641337386, 1e-12);

## A confidence interval is returned on either side of the estimate.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! [x0, dxlo, dxup] = invpred (x, y, 20);
%! assert_equal (x0, 5.964741641337386, 1e-12);
%! assert_equal (dxlo, 0.408566704275405, 1e-12);
%! assert_equal (dxup, 0.410279499114103, 1e-12);

## The interval is not symmetric about the estimate.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! [~, dxlo, dxup] = invpred (x, y, 20);
%! assert_equal (dxlo != dxup, true);

## Y0 may hold several values, and the output follows its shape.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! [x0, dxlo, dxup] = invpred (x, y, [10; 20; 30]);
%! assert_equal (x0, [2.621276595744681; 5.964741641337386; ...
%!                    9.308206686930092], 1e-12);
%! assert_equal (dxlo, [0.432537159571881; 0.408566704275405; ...
%!                      0.433439039304474], 1e-12);
%! assert_equal (dxup, [0.421927689383959; 0.410279499114103; ...
%!                      0.447474099169791], 1e-12);
%! [x0r, dxlor, dxupr] = invpred (x, y, [10, 20, 30]);
%! assert_equal (x0r, x0');
%! assert_equal (dxlor, dxlo');
%! assert_equal (dxupr, dxup');

## A matrix of responses is returned as a matrix.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! x0 = invpred (x, y, [10, 20; 30, 40]);
%! assert_equal (size (x0), [2, 2]);
%! assert_equal (x0, [2.621276595744681, 5.964741641337386; ...
%!                    9.308206686930092, 12.651671732522798], 1e-12);

## An empty Y0 gives an empty result.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! x0 = invpred (x, y, []);
%! assert_equal (size (x0), [0, 0]);

## ALPHA widens the interval without moving the estimate.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! [x0, dxlo, dxup] = invpred (x, y, 20, 'alpha', 0.01);
%! assert_equal (x0, 5.964741641337386, 1e-12);
%! assert_equal (dxlo, 0.594536204654897, 1e-12);
%! assert_equal (dxup, 0.598170042325828, 1e-12);

## An interval on the curve is narrower than one on a new observation.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! [x0, dxlo, dxup] = invpred (x, y, 20, 'predopt', 'curve');
%! assert_equal (x0, 5.964741641337386, 1e-12);
%! assert_equal (dxlo, 0.124048892442359, 1e-12);
%! assert_equal (dxup, 0.125761687281057, 1e-12);
%! [~, obslo, obsup] = invpred (x, y, 20, 'predopt', 'observation');
%! assert_equal (dxlo < obslo && dxup < obsup, true);

## A slope indistinguishable from zero leaves the interval unbounded.
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [1; 5; 2; 8; 3], 4);
%! assert_equal (x0, 3.285714285714286, 1e-12);
%! assert_equal (dxlo, Inf);
%! assert_equal (dxup, Inf);

## Rows and columns are accepted alike.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! [x0, dxlo, dxup] = invpred (x', y', 20);
%! assert_equal (x0, 5.964741641337386, 1e-12);
%! assert_equal (dxlo, 0.408566704275405, 1e-12);
%! assert_equal (dxup, 0.410279499114103, 1e-12);

## Observations missing in either variable are dropped in pairs.
%!test
%! x = (1:10)';
%! y = 2 + 3 * x + [0.5; -0.3; 0.2; 0.8; -0.6; 0.1; -0.4; 0.7; -0.2; 0.3];
%! xn = x; xn(3) = NaN;
%! assert_equal (invpred (xn, y, 20), 5.967084254482929, 1e-12);
%! yn = y; yn(4) = NaN;
%! assert_equal (invpred (x, yn, 20), 5.988352745424295, 1e-12);

## When the slope is not significant, one side of the interval may be
## unbounded while the other stays finite.
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [1; 5; 2; 8; 3], 100);
%! assert_equal (x0, 140.42857142857144, 1e-12);
%! assert_equal (dxlo, 111.30773209684287, 1e-12);
%! assert_equal (dxup, Inf);

## Y0 may hold several values even when the interval is one-sided in
## different directions for different elements.
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [1; 5; 2; 8; 3], [-100; 100]);
%! assert_equal (x0, [-145.28571428571428; 140.42857142857144], 1e-12);
%! assert_equal (dxlo, [Inf; 111.30773209684287], 1e-12);
%! assert_equal (dxup, [120.07306008453997; Inf], 1e-12);
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [1; 5; 2; 8; 3], [100; 200]);
%! assert_equal (x0, [140.42857142857144; 283.2857142857143], 1e-12);
%! assert_equal (dxlo, [111.30773209684287; 226.72556884927243], 1e-12);
%! assert_equal (dxup, [Inf; Inf], 1e-12);

## Two observations leave no residual degrees of freedom.
%!test
%! [x0, dxlo, dxup] = invpred ([1; 2], [1; 3], 5);
%! assert_equal (x0, 3, 1e-12);
%! assert_equal (isnan ([dxlo, dxup]), [true, true]);

## A NaN response has no interval, even when the slope is not significant.
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [1; 5; 2; 8; 3], NaN);
%! assert_equal (isnan ([x0, dxlo, dxup]), [true, true, true]);

## A weak slope at a large ALPHA gives a bounded, strongly asymmetric interval.
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [1; 5; 2; 8; 3], [-100; 10], ...
%!                             'alpha', 0.6);
%! assert_equal (x0, [-145.285714285714; 11.8571428571429], 1e-10);
%! assert_equal (dxlo, [512.850040050218; 4.3868758019588], 1e-10);
%! assert_equal (dxup, [64.8087843549742; 31.1484922307691], 1e-10);

## A negative slope mirrors the one-sided intervals.
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [3; 8; 2; 5; 1], [-100; 100]);
%! assert_equal (x0, [151.285714285714; -134.428571428571], 1e-10);
%! assert_equal (dxlo, [120.07306008454; Inf], 1e-10);
%! assert_equal (dxup, [Inf; 111.307732096843], 1e-10);

## At the mean response with a non-significant slope the interval starts at x0.
%!test
%! y = [1; 5; 2; 8; 3];
%! [x0, dxlo, dxup] = invpred ((1:5)', y, mean (y));
%! assert_equal (x0, 3, 1e-12);
%! assert_equal (dxlo, 0, 1e-12);
%! assert_equal (dxup, Inf);

## For a negative slope the unbounded side is the lower one.
%!test
%! y = [3; 8; 2; 5; 1];
%! [x0, dxlo, dxup] = invpred ((1:5)', y, mean (y), 'alpha', 0.6);
%! assert_equal (x0, 3, 1e-12);
%! assert_equal (dxlo, Inf);
%! assert_equal (dxup, 0, 1e-12);

## Infinite responses leave the bound on the side x0 diverges towards undefined.
%!test
%! [x0, dxlo, dxup] = invpred ((1:5)', [1; 5; 2; 8; 3], [-Inf; Inf]);
%! assert_equal (x0, [-Inf; Inf]);
%! assert_equal (isnan (dxlo), [true; false]);
%! assert_equal (dxlo(2), Inf);
%! assert_equal (isnan (dxup), [false; true]);
%! assert_equal (dxup(1), Inf);

%!error<Invalid call to invpred> invpred ((1:10)', (1:10)')
%!error<invpred: X must be a vector of real values.> ...
%! invpred (ones (10, 2), (1:10)', 5)
%!error<invpred: Y must be a vector of real values.> ...
%! invpred ((1:10)', ones (10, 2), 5)
%!error<invpred: X and Y must have the same length.> ...
%! invpred ((1:10)', (1:5)', 5)
%!error<invpred: ALPHA must be a scalar strictly between 0 and 1.> ...
%! invpred ((1:10)', (1:10)', 5, 'alpha', 5)
%!error<invpred: ALPHA must be a scalar strictly between 0 and 1.> ...
%! invpred ((1:10)', (1:10)', 5, 'alpha', [0.05, 0.01])
%!error<invpred: PREDOPT value must be 'curve' or 'observation'.> ...
%! invpred ((1:10)', (1:10)', 5, 'predopt', 'bogus')
%!error<invpred: invalid parameter name: badname.> ...
%! invpred ((1:10)', (1:10)', 5, 'badname', 1)
%!error<invpred: optional arguments must be name-value pairs.> ...
%! invpred ((1:10)', (1:10)', 5, 'alpha')
%!error<invpred: cannot compute inverse predictions if X is constant.> ...
%! invpred (ones (10, 1), (1:10)', 5)

(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2013 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)

#define
ATS_PACKNAME "ATSLIB.libats.funarray"
#define
ATS_DYNLOADFLAG 0 // no dynamic loading at run-time

(* ****** ****** *)

staload
UN = "prelude/SATS/unsafe.sats"
staload
_(*anon*) = "prelude/DATS/integer.dats"

(* ****** ****** *)
//
staload "libats/SATS/funarray.sats"
//
(* ****** ****** *)

datatype
brauntree
  (a:t@ype+, int) =
  | E (a, 0) of ()
  | {n1,n2:nat | n2 <= n1; n1 <= n2+1}
    B (a, n1+n2+1) of (a, brauntree (a, n1), brauntree (a, n2))
// end of [brauntree]

stadef bt = brauntree

(* ****** ****** *)
//
assume
funarray_t0ype_int_type
  (a:t@ype, n:int) = brauntree(a, n)
//
(* ****** ****** *)

implement
funarray_make_nil((*void*)) = E(*void*)

(* ****** ****** *)

implement
{a}(*tmp*)
funarray_size
  (A) = let
//
fun
diff
{ nl,nr:nat
| nr <= nl && nl <= nr+1
} .<nr>. 
(
  nr: int(nr), t0: bt(a, nl)
) : int (nl-nr) =
(
case+ t0 of
| E () => 0
| B (_, tl, tr) =>
   if nr > 0
     then let
       val nr2 = half(nr)
     in
       if nr > nr2 + nr2 then diff (nr2, tl) else diff (nr2-1, tr)
     end // end of [then]
     else 1 // end of [else]
  // end of [diff]
) (* end of [diff] *)
//
fun
size
{n:nat} .<n>.
(
  t0: bt(a, n)
) : int(n) =
(
case+ t0 of
| E () => 0
| B (_, tl, tr) => let
    val nr = size(tr)
    val d1 = 1 + diff(nr, tl)
  in
    2 * nr + d1
  end // end of [B]
  // end of [size]
) (* end of [size] *)
//
prval() = lemma_funarray_param(A)
//
in
  size(A)
end // end of [funarray_size]
//
(* ****** ****** *)

implement
{a}(*tmp*)
funarray_get_at
  {n}(A, i) = let
//
fun
get_at
{
n,i:nat| i < n
} .<n>.
(
  t0: bt(a, n), i: int i
) : a =
(
if
i > 0
then let
  val i2 = half(i)
in
  if i > i2 + i2
    then let
      val+B(_, tl, _) = t0 in get_at (tl, i2)
    end // end of [then]
    else let
      val+B(_, _, tr) = t0 in get_at (tr, i2-1)
    end // end of [else]
end // end of [then]
else let
  val+B(x, _, _) = t0 in x
end // end of [else]
) (* end of [get_at] *)
//
in
  get_at(A, i)
end // end of [funarray_get_at]

(* ****** ****** *)

implement
{a}(*tmp*)
funarray_set_at
  {n}(A, i, x0) = let
//
fun
set_at
{
  n,i:nat | i < n
} .<n>.
(
  t0: bt(a, n), i: int i, x0: a
) : bt(a, n) =
(
if
i > 0
then let
  val i2 = half(i)
  val+B(x, tl, tr) = t0
in
  if i > i2 + i2
    then B(x, set_at (tl, i2, x0), tr)
    else B(x, tl, set_at (tr, i2-1, x0))
  // end of [if]
end // end of [then]
else let
  val+B(_, t1, t2) = t0 in B(x0, t1, t2)
end // end of [else]
//
) (* end of [set_at] *)
//
in
  A := set_at(A, i, x0)
end // end of [funarray_set_at]
//
(* ****** ****** *)

implement
{a}(*tmp*)
funarray_insert_l
  {n}(A, x0) = let
//
fun
ins_l
{n:nat} .<n>.
(
  t0: bt(a, n), x0: a
) :<> bt(a, n+1) =
(
case+ t0 of
| E () => B (x0, E (), E ())
| B (x, tl, tr) => B (x0, ins_l (tr, x), tl)
) (* end of [ins_l] *)
//
prval() = lemma_funarray_param(A)
//
in
  A := ins_l(A, x0)
end // end of [funarray_insert_l]

(* ****** ****** *)

implement
{a}(*tmp*)
funarray_insert_r
  {n}(A, n, x0) = let
//
fun
ins_r
{n:nat} .<n>.
(
  t0: bt(a, n), n: int n, x0: a
) : bt(a, n+1) =
(
//
if
n > 0
then let
  val n2 = half(n)
  val+B(x, tl, tr) = t0
in
  if n > n2 + n2
    then B(x, ins_r (tl, n2, x0), tr)
    else B(x, tl, ins_r (tr, n2-1, x0))
  // end of [if]
end // end of [then]
else B (x0, E (), E ())
//
) (* end of [ins_r] *)
//
prval() = lemma_funarray_param(A)
//
in
  A := ins_r(A, n, x0)
end // end of [funarray_insert_r]

(* ****** ****** *)

implement
{a}(*tmp*)
funarray_remove_l
  {n}(A) = let
//
fun
rem_l
{n:pos} .<n>.
(
  t0: &bt(a, n) >> bt(a, n-1)
) : a =
(
case+ t0 of
| B(x, E(), _) => (t0 := E(); x)
| B(xl, tl, tr) =>> let
    var tl = tl
    val x0 = rem_l(tl) in (t0 := B(xl, tr, tl); x0)
  end // end of [lorem]
)
//
in
  rem_l(A)
end // end of [funarray_remove_l]
//
(* ****** ****** *)

implement
{a}(*tmp*)
funarray_remove_r
  {n}(A, n) = let
//
fun
rem_r
{n:pos} .<n>.
(
  t0: &bt(a, n) >> bt(a, n-1), n: int n
) : a = let
//
val n2 = half(n); val+ B (x, tl, tr) = t0
//
in
//
case+ tl of
| E() => (t0 := E(); x)
| B _ =>
  if n > n2 + n2
    then let
      var tr = tr
      val x0 = rem_r(tr, n2) in t0 := B(x, tl, tr); x0
    end // end of [then]
    else let
      var tl = tl
      val x0 = rem_r(tl, n2) in t0 := B(x, tl, tr); x0
    end // end of [else]
  // end of [if]
//
end // end of [rem_r]
//
in
  rem_r(A, n)
end // end of [funarray_remove_r]

(* ****** ****** *)

(* end of [funarray.dats] *)
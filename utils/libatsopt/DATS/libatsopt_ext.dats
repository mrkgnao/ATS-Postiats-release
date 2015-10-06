(*
//
// For [libatsopt]
//
*)

(* ****** ****** *)

#define ATS_DYNLOADFLAG 0

(* ****** ****** *)
//
staload
UN =
"prelude/SATS/unsafe.sats"
//
staload
_ = "prelude/DATS/unsafe.dats"
//
(* ****** ****** *)

staload
_ = "prelude/DATS/list.dats"
staload
_ = "prelude/DATS/array.dats"

(* ****** ****** *)
//
staload
FIL = "src/pats_filename.sats"
//
(* ****** ****** *)
//
staload "src/pats_syntax.sats"
//
staload "src/pats_parsing.sats"
//
(* ****** ****** *)
//
staload "src/pats_staexp1.sats"
staload "src/pats_dynexp1.sats"
//
staload
TRANS1 = "src/pats_trans1.sats"
staload
TRENV1 = "src/pats_trans1_env.sats"
//
(* ****** ****** *)
//
staload "src/pats_staexp2.sats"
staload "src/pats_stacst2.sats"
staload "src/pats_dynexp2.sats"
//
staload
TRANS2 = "src/pats_trans2.sats"
staload
TRENV2 = "src/pats_trans2_env.sats"
//
(* ****** ****** *)
//
staload "src/pats_dynexp3.sats"
//
staload
TRANS3 = "src/pats_trans3.sats"
staload
TRENV3 = "src/pats_trans3_env.sats"
//
(* ****** ****** *)
//
staload "src/pats_histaexp.sats"
staload "src/pats_hidynexp.sats"
//
staload
TYER = "src/pats_typerase.sats"
//
staload CCOMP = "src/pats_ccomp.sats"
//
(* ****** ****** *)

staload "./../SATS/libatsopt_ext.sats"

(* ****** ****** *)
//
%{^
//
extern void patsopt_PATSHOME_set() ;
extern char *patsopt_PATSHOME_get() ;
//
%} // end of [{^]
//
implement
PATSHOME_set
  ((*void*)) = let
//
val () = set() where
{
extern
fun
set (
// argumentless
) : void =
  "mac#patsopt_PATSHOME_set"
//
} // end of [where]
//
prval pf = __assert() where
{
  extern prfun __assert(): PATSHOME_set_p  
} (* end of [prval] *)
//
in
  (pf | ((*void*)))
end // end of [PATSHOME_set]
//
implement
PATSHOME_get
(
  pf | (*none*)
) = let
//
val opt = get() where
{
extern
fun
get (
// argumentless
) : Stropt =
  "mac#patsopt_PATSHOME_get"
//
} (* end of [where] *)
val issome = stropt_is_some (opt)
//
in
  if issome
    then stropt_unsome(opt) else "$(PATSHOME)"
  // end of [if]
end // end of [PATSHOME_get]
//
(* ****** ****** *)

implement
string2file
  (content, nerr) = let
//
val () = nerr := nerr + 1
//
in
  "/tmp/string2file_dummy"
end // end of [string2file]

(* ****** ****** *)

implement
patsopt_main_list
  {n}(args) = let
//
fun
loop
{l:addr}
(
  xs: List(comarg)
, p0: ptr(l), nerr: &int >> int
) : void =
(
case+ xs of
| list_nil() => ()
| list_cons(x, xs) => let
    val x =
    (
      case+ x of
      | COMARGstring(x) => x
      | COMARGfilinp(x) => string2file(x, nerr)
    ) : string // end of [val]
    val () =
      $UN.ptr0_set<string>(p0, x)
    // end of [val]
  in
    loop(xs, p0+sizeof<string>, nerr)
  end // end of [list_cons]
)
//
var
nerr: int = 0
//
val
argc = list_length(args)
val
asz0 = size1_of_int1(argc)
//
val
(pfgc, pfarr | p0) =
array_ptr_alloc<string> (asz0)
//
val ((*void*)) = loop(args, p0, nerr)
//
val ((*void*)) = (
//
if
nerr = 0
then let
//
val
(pfarr,fpf|argv) =
$UN.ptr1_vtake{@[string][n]}(p0)
//
val () = patsopt_main(argc, !argv)
//
prval ((*returned*)) = fpf(pfarr)
//
in
  // nothing
end // end of [then]
else ((*void*)) // end of [else]
//
) (* end of [if] *)
//
val () = array_ptr_free(pfgc, pfarr | p0)
//
in
  nerr
end // end of [patsopt_main_list]

(* ****** ****** *)
//
extern
fun
patsopt_tcats_d3eclist_exn
  (stadyn: int, inp: string): d3eclist
extern
fun
patsopt_tcats_d3eclist_opt
  (stadyn: int, inp: string): Option_vt(d3eclist)
//
(* ****** ****** *)

implement
patsopt_tcats_d3eclist_exn
  (stadyn, inp) = let
//
val fil = $FIL.filename_string
//
val (pf|()) =
  $FIL.the_filenamelst_push(fil)
//
val
d0cs =
parse_from_string_toplevel(stadyn, inp)
//
val ((*void*)) =
  $FIL.the_filenamelst_pop(pf|(*none*))
//
val
(pf|()) = PATSHOME_set()
val
PATSHOME = PATSHOME_get(pf|(*none*))
//
val () =
  $FIL.the_prepathlst_push(PATSHOME)
val () =
  $TRENV1.the_trans1_env_initialize()
val () =
  $TRENV2.the_trans2_env_initialize()
//
val () = the_prelude_load(PATSHOME)
//
val () = $FIL.the_filenamelst_ppush(fil)
//
val d1cs = $TRANS1.d0eclist_tr_errck(d0cs)
//
val () = $TRANS1.trans1_finalize((*void*))
//
val d2cs = $TRANS2.d1eclist_tr_errck (d1cs)
//
val () =
  $TRENV3.the_trans3_env_initialize()
//
val d3cs = $TRANS3.d2eclist_tr_errck(d2cs)
//
(*
val () = fprint_d0eclist(stdout_ref, d0cs)
val () = fprint_d1eclist(stdout_ref, d1cs)
val () = fprint_d2eclist(stdout_ref, d2cs)
val () = fprint_d3eclist(stdout_ref, d3cs)
*)
//
in
//
  d3cs
//
end // end of [patsopt_tcats_d3eclst]

(* ****** ****** *)

local
//
fun
auxexn
(
  exn: exn
) : Option_vt(d3eclist) =
(
case+ exn of 
//
| exn => let
    val p0 = $UN.castvwtp0{ptr}(exn) in None_vt()
  end // end of [rest]
) (* en dof [auxexn] *)
//
in (*in-of-local*)

implement
patsopt_tcats_d3eclist_opt
  (stadyn, inp) = let
//
(*
val () =
println!
(
  "patsopt_tcats_d3eclist_opt"
) (* end of [val] *)
*)
//
in
//
try let
//
val
d3cs =
patsopt_tcats_d3eclist_exn(stadyn, inp)
//
in
  Some_vt(d3cs)
end with exn => auxexn(exn)
//
end // end of [patsopt_tcats_d3eclist_opt]

end // end of [local]

(* ****** ****** *)

(* end of [libatsopt_ext.dats] *)
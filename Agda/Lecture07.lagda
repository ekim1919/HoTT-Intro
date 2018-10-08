\begin{code}

{-# OPTIONS --without-K --allow-unsolved-metas #-}

module Lecture07 where

import Lecture06
open Lecture06 public

-- Section 7.1 Fiberwise equivalences
tot : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → ((x : A) → B x → C x) → ( Σ A B → Σ A C)
tot f (dpair x y) = dpair x (f x y)

-- There is a function from the fibers of the induced map on total spaces, to the fibers of the fiberwise transformation
fib-ftr-fib-tot : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → (f : (x : A) → B x → C x) → (t : Σ A C) → fib (tot f) t → fib (f (pr1 t)) (pr2 t)
fib-ftr-fib-tot f .(dpair x (f x y)) (dpair (dpair x y) refl) = dpair y refl

-- This function has a converse
fib-tot-fib-ftr : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → (f : (x : A) → B x → C x) → (t : Σ A C) → fib (f (pr1 t)) (pr2 t) → fib (tot f) t
fib-tot-fib-ftr F (dpair a .(F a y)) (dpair y refl) = dpair (dpair a y) refl

issec-fib-tot-fib-ftr : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → (f : (x : A) → B x → C x) → (t : Σ A C) → ((fib-ftr-fib-tot f t) ∘ (fib-tot-fib-ftr f t)) ~ id
issec-fib-tot-fib-ftr f (dpair x .(f x y)) (dpair y refl) = refl

isretr-fib-tot-fib-ftr : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → (f : (x : A) → B x → C x) → (t : Σ A C) → ((fib-tot-fib-ftr f t) ∘ (fib-ftr-fib-tot f t)) ~ id
isretr-fib-tot-fib-ftr f .(dpair x (f x y)) (dpair (dpair x y) refl) = refl

-- We establish that the fibers of the induced map on total spaces are equivalent to the fibers of the fiberwise transformation.
is-equiv-fib-ftr-fib-tot : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → (f : (x : A) → B x → C x) → (t : Σ A C) → is-equiv (fib-ftr-fib-tot f t)
is-equiv-fib-ftr-fib-tot f t =
  pair
    (dpair (fib-tot-fib-ftr f t) (issec-fib-tot-fib-ftr f t))
    (dpair (fib-tot-fib-ftr f t) (isretr-fib-tot-fib-ftr f t))

is-equiv-fib-tot-fib-ftr : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → (f : (x : A) → B x → C x) → (t : Σ A C) → is-equiv (fib-tot-fib-ftr f t)
is-equiv-fib-tot-fib-ftr f t =
  pair
    ( dpair (fib-ftr-fib-tot f t) (isretr-fib-tot-fib-ftr f t))
    ( dpair (fib-ftr-fib-tot f t) (issec-fib-tot-fib-ftr f t))

-- Any fiberwise equivalence induces an equivalence on total spaces
is-fiberwise-equiv : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} → ((x : A) → B x → C x) → UU (i ⊔ (j ⊔ k))
is-fiberwise-equiv f = (x : _) → is-equiv (f x)

is-equiv-tot-is-fiberwise-equiv :
  {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} →
  (f : (x : A) → B x → C x) → is-fiberwise-equiv f →
  is-equiv (tot f )
is-equiv-tot-is-fiberwise-equiv f H =
  is-equiv-is-contr-map
    ( λ t → is-contr-is-equiv _
      ( fib-ftr-fib-tot f t)
      ( is-equiv-fib-ftr-fib-tot f t)
      ( is-contr-map-is-equiv (H _) (pr2 t)))

-- Conversely, any fiberwise transformation that induces an equivalence on total spaces is a fiberwise equivalence.
is-fiberwise-equiv-is-equiv-tot :
  {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k} →
  (f : (x : A) → B x → C x) → is-equiv (tot f) →
  is-fiberwise-equiv f
is-fiberwise-equiv-is-equiv-tot f H x =
  is-equiv-is-contr-map
    (λ z → is-contr-is-equiv' _
      (fib-ftr-fib-tot f (dpair x z))
      (is-equiv-fib-ftr-fib-tot f (dpair x z))
      (is-contr-map-is-equiv H (dpair x z)))

-- Section 7.2 The fundamental theorem

-- The general form of the fundamental theorem of identity types
id-fundamental-gen : {i j : Level} {A : UU i} {B : A → UU j} (a : A) (b : B a) → is-contr (Σ A B) → (f : (x : A) → Id a x → B x) → is-fiberwise-equiv f
id-fundamental-gen {_} {_} {A} {B} a b C f x =
  is-fiberwise-equiv-is-equiv-tot f
    (is-equiv-is-contr _ (is-contr-total-path A a) C) x

id-fundamental-gen' : {i j : Level} {A : UU i} {B : A → UU j}
  (a : A) (b : B a) (f : (x : A) → Id a x → B x) → is-fiberwise-equiv f →
  is-contr (Σ A B)
id-fundamental-gen' {A = A} {B = B} a b f is-fiberwise-equiv-f =
  is-contr-is-equiv'
    ( Σ A (Id a))
    ( tot f)
    ( is-equiv-tot-is-fiberwise-equiv f is-fiberwise-equiv-f)
    ( is-contr-total-path A a)

-- The canonical form of the fundamental theorem of identity types
id-fundamental : {i j : Level} {A : UU i} {B : A → UU j} (a : A) (b : B a) →
  is-contr (Σ A B) → is-fiberwise-equiv (ind-Id a (λ x p → B x) b)
id-fundamental {i} {j} {A} {B} a b H =
  id-fundamental-gen a b H (ind-Id a (λ x p → B x) b)

-- The converse of the fundamental theorem of identity types
id-fundamental' : {i j : Level} {A : UU i} {B : A → UU j} (a : A) (b : B a) →
  (is-fiberwise-equiv (ind-Id a (λ x p → B x) b)) → is-contr (Σ A B)
id-fundamental' {i} {j} {A} {B} a b H =
  is-contr-is-equiv' _
    (tot (ind-Id a (λ x p → B x) b))
    (is-equiv-tot-is-fiberwise-equiv _ H)
    (is-contr-total-path A a)

-- As an application we show that equivalences are embeddings.
is-emb : {i j : Level} {A : UU i} {B : UU j} (f : A → B) → UU (i ⊔ j)
is-emb f = (x y : _) → is-equiv (ap f {x} {y})

is-emb-is-equiv : {i j : Level} {A : UU i} {B : UU j} (f : A → B) → is-equiv f → is-emb f
is-emb-is-equiv {i} {j} {A} {B} f E x =
  id-fundamental-gen x refl
    (is-contr-is-equiv' _ (tot (λ y (p : Id (f y) (f x)) → inv p))
        (is-equiv-tot-is-fiberwise-equiv _ (λ y → is-equiv-inv (f y) (f x)))
      (is-contr-map-is-equiv E (f x)))
    (λ y p → ap f p)

-- Exercises

-- Exercise 7.1

tot-htpy : {i j k : Level} {A : UU i} {B : A → UU j} {C : A → UU k}
  {f g : (x : A) → B x → C x} → (H : (x : A) → f x ~ g x) → tot f ~ tot g
tot-htpy H (dpair x y) = eq-pair (dpair refl (H x y))

tot-id : {i j : Level} {A : UU i} (B : A → UU j) →
  (tot (λ x (y : B x) → y)) ~ id
tot-id B (dpair x y) = refl

tot-comp : {i j j' j'' : Level}
  {A : UU i} {B : A → UU j} {B' : A → UU j'} {B'' : A → UU j''}
  (f : (x : A) → B x → B' x) (g : (x : A) → B' x → B'' x) →
  tot (λ x → (g x) ∘ (f x)) ~ ((tot g) ∘ (tot f))
tot-comp f g (dpair x y) = refl

-- Exercise 7.2
fib' : {i j : Level} {A : UU i} {B : UU j} → (A → B) → B → UU (i ⊔ j)
fib' f y = Σ _ (λ x → Id y (f x))

fib'-fib : {i j : Level} {A : UU i} {B : UU j} (f : A → B) (y : B) →
  fib f y → fib' f y
fib'-fib f y t = tot (λ x → inv) t

is-equiv-fib'-fib : {i j : Level} {A : UU i} {B : UU j}
  (f : A → B) → is-fiberwise-equiv (fib'-fib f)
is-equiv-fib'-fib f y =
  is-equiv-tot-is-fiberwise-equiv (λ x → inv) (λ x → is-equiv-inv (f x) y)

-- Exercise 7.3
is-equiv-top-is-equiv-bottom-square :
  {l1 l2 l3 l4 : Level} {A : UU l1} {B : UU l2} {C : UU l3} {D : UU l4}
  (f : A → B) (g : C → D) (h : A → C) (i : B → D) (H : (i ∘ f) ~ (g ∘ h)) →
  (is-equiv f) → (is-equiv g) → (is-equiv i) → (is-equiv h)
is-equiv-top-is-equiv-bottom-square f g h i H Ef Eg Ei =
  is-equiv-right-factor (i ∘ f) g h H Eg
    (is-equiv-comp (i ∘ f) i f (htpy-refl _) Ef Ei)

is-equiv-bottom-is-equiv-top-square :
  {l1 l2 l3 l4 : Level} {A : UU l1} {B : UU l2} {C : UU l3} {D : UU l4}
  (f : A → B) (g : C → D) (h : A → C) (i : B → D) (H : (i ∘ f) ~ (g ∘ h)) →
  (is-equiv f) → (is-equiv g) → (is-equiv h) → (is-equiv i)
is-equiv-bottom-is-equiv-top-square f g h i H Ef Eg Eh =
  is-equiv-left-factor (g ∘ h) i f (htpy-inv H)
    (is-equiv-comp (g ∘ h) g h (htpy-refl _) Eh Eg) Ef

fib-triangle : {i j k : Level} {X : UU i} {A : UU j} {B : UU k}
  (f : A → X) (g : B → X) (h : A → B) (H : f ~ (g ∘ h))
  (x : X) → (fib f x) → (fib g x)
fib-triangle f g h H .(f a) (dpair a refl) = dpair (h a) (inv (H a))

square-tot-fib-triangle : {i j k : Level} {X : UU i} {A : UU j} {B : UU k}
  (f : A → X) (g : B → X) (h : A → B) (H : f ~ (g ∘ h)) →
  (h ∘ (Σ-fib-to-domain f)) ~
  ((Σ-fib-to-domain g) ∘ (tot (fib-triangle f g h H)))
square-tot-fib-triangle f g h H (dpair .(f a) (dpair a refl)) = refl

is-fiberwise-equiv-is-equiv-triangle : {i j k : Level}
  {X : UU i} {A : UU j} {B : UU k}
  (f : A → X) (g : B → X) (h : A → B) (H : f ~ (g ∘ h)) →
  (E : is-equiv h) → is-fiberwise-equiv (fib-triangle f g h H)
is-fiberwise-equiv-is-equiv-triangle f g h H E =
  is-fiberwise-equiv-is-equiv-tot
    ( fib-triangle f g h H)
    ( is-equiv-top-is-equiv-bottom-square
      ( Σ-fib-to-domain f)
      ( Σ-fib-to-domain g)
      ( tot (fib-triangle f g h H))
      ( h)
      ( square-tot-fib-triangle f g h H)
      ( is-equiv-Σ-fib-to-domain f)
      ( is-equiv-Σ-fib-to-domain g)
      ( E))

is-equiv-triangle-is-fiberwise-equiv :
  {i j k : Level} {X : UU i} {A : UU j} {B : UU k}
  (f : A → X) (g : B → X) (h : A → B) (H : f ~ (g ∘ h)) →
  (E : is-fiberwise-equiv (fib-triangle f g h H)) → is-equiv h
is-equiv-triangle-is-fiberwise-equiv f g h H E =
  is-equiv-bottom-is-equiv-top-square
    ( Σ-fib-to-domain f)
    ( Σ-fib-to-domain g)
    ( tot (fib-triangle f g h H))
    ( h)
    ( square-tot-fib-triangle f g h H)
    ( is-equiv-Σ-fib-to-domain f)
    ( is-equiv-Σ-fib-to-domain g)
    ( is-equiv-tot-is-fiberwise-equiv (fib-triangle f g h H) E)

-- Exercise 7.4
fib-ap-eq-fib-fiberwise : {i j : Level} {A : UU i} {B : UU j}
  (f : A → B) {b : B} (s t : fib f b) (p : Id (pr1 s) (pr1 t)) →
  (Id (tr (λ (a : A) → Id (f a) b) p (pr2 s)) (pr2 t)) →
  (Id (ap f p) (concat b (pr2 s) (inv (pr2 t))))
fib-ap-eq-fib-fiberwise f (dpair .x' p) (dpair x' refl) refl =
  inv ∘ (concat p (right-unit p))

is-fiberwise-equiv-fib-ap-eq-fib-fiberwise :
  {i j : Level} {A : UU i} {B : UU j} (f : A → B) {b : B} (s t : fib f b) →
  is-fiberwise-equiv (fib-ap-eq-fib-fiberwise f s t)
is-fiberwise-equiv-fib-ap-eq-fib-fiberwise
  f (dpair x y) (dpair .x refl) refl =
  is-equiv-comp
    ( fib-ap-eq-fib-fiberwise f (dpair x y) (dpair x refl) refl)
    ( inv)
    ( concat y (right-unit y))
    ( htpy-refl (fib-ap-eq-fib-fiberwise f (dpair x y) (dpair x refl) refl))
    ( is-equiv-concat (right-unit y) refl)
    ( is-equiv-inv (concat (f x) y refl) refl)

fib-ap-eq-fib : {i j : Level} {A : UU i} {B : UU j} (f : A → B) {b : B}
  (s t : fib f b) → Id s t →
  fib (ap f {x = pr1 s} {y = pr1 t}) (concat _ (pr2 s) (inv (pr2 t)))
fib-ap-eq-fib f s .s refl = dpair refl (inv (right-inv (pr2 s)))

triangle-fib-ap-eq-fib : {i j : Level} {A : UU i} {B : UU j} (f : A → B)
  {b : B} (s t : fib f b) →
  (fib-ap-eq-fib f s t) ~ ((tot (fib-ap-eq-fib-fiberwise f s t)) ∘ (pair-eq' s t))
triangle-fib-ap-eq-fib f (dpair x refl) .(dpair x refl) refl = refl

is-equiv-fib-ap-eq-fib : {i j : Level} {A : UU i} {B : UU j} (f : A → B) {b : B}
  (s t : fib f b) → is-equiv (fib-ap-eq-fib f s t)
is-equiv-fib-ap-eq-fib f s t =
  is-equiv-comp
    ( fib-ap-eq-fib f s t)
    ( tot (fib-ap-eq-fib-fiberwise f s t))
    ( pair-eq' s t)
    ( triangle-fib-ap-eq-fib f s t)
    ( is-equiv-pair-eq' s t)
    ( is-equiv-tot-is-fiberwise-equiv
      ( fib-ap-eq-fib-fiberwise f s t)
      ( is-fiberwise-equiv-fib-ap-eq-fib-fiberwise f s t))

eq-fib-fib-ap : {i j : Level} {A : UU i} {B : UU j} (f : A → B) (x y : A) (q : Id (f x) (f y)) → Id (dpair x q) (dpair y (refl {x = f y})) → fib (ap f {x = x} {y = y}) q
eq-fib-fib-ap f x y q = (tr (fib (ap f)) (right-unit q)) ∘ (fib-ap-eq-fib f (dpair x q) (dpair y refl))

is-equiv-eq-fib-fib-ap : {i j : Level} {A : UU i} {B : UU j} (f : A → B) (x y : A) (q : Id (f x) (f y)) → is-equiv (eq-fib-fib-ap f x y q)
is-equiv-eq-fib-fib-ap f x y q =
  is-equiv-comp
    ( eq-fib-fib-ap f x y q)
    ( tr (fib (ap f)) (right-unit q))
    ( fib-ap-eq-fib f (dpair x q) (dpair y refl))
    ( htpy-refl _)
    ( is-equiv-fib-ap-eq-fib f (dpair x q) (dpair y refl))
    ( is-equiv-tr (fib (ap f)) (right-unit q))

-- Exercise 7.5

-- This exercise was already done in id-fundamental-gen above.

-- Exercise 7.6
id-fundamental-retr : {i j : Level} {A : UU i} {B : A → UU j} (a : A) →
  (i : (x : A) → B x → Id a x) → (R : (x : A) → retr (i x)) →
  is-fiberwise-equiv i
id-fundamental-retr {_} {_} {A} {B} a i R =
  is-fiberwise-equiv-is-equiv-tot i
    ( is-equiv-is-contr (tot i)
      ( is-contr-retract-of (Σ _ (λ y → Id a y))
        ( dpair (tot i)
          ( dpair (tot λ x → pr1 (R x))
            ( htpy-concat
              ( tot (λ x → pr1 (R x) ∘ i x))
              ( htpy-inv (tot-comp i (λ x → pr1 (R x))))
                ( htpy-concat (tot (λ x → id))
                  ( tot-htpy λ x → pr2 (R x))
                  ( tot-id B)))))
        ( is-contr-total-path _ a))
      ( is-contr-total-path _ a))

is-equiv-sec-is-equiv : {i j : Level} {A : UU i} {B : UU j} (f : A → B) (sec-f : sec f) → is-equiv (pr1 sec-f) → is-equiv f
is-equiv-sec-is-equiv {A = A} {B = B} f (dpair g issec-g) is-equiv-sec-f =
  let h : A → B
      h = inv-is-equiv is-equiv-sec-f
  in is-equiv-htpy
    ( htpy-concat
      ( f ∘ (g ∘ h))
      ( htpy-left-whisk f (htpy-inv (issec-inv-is-equiv is-equiv-sec-f)))
      ( htpy-right-whisk issec-g h))
    ( is-equiv-inv-is-equiv is-equiv-sec-f)

id-fundamental-sec : {i j : Level} {A : UU i} {B : A → UU j} (a : A)
  (f : (x : A) → Id a x → B x) → ((x : A) → sec (f x)) →
  is-fiberwise-equiv f
id-fundamental-sec {A = A} {B = B} a f sec-f x =
  let i : (x : A) → B x → Id a x
      i = λ x → pr1 (sec-f x)
      retr-i : (x : A) → retr (i x)
      retr-i = λ x → dpair (f x) (pr2 (sec-f x))
      is-fiberwise-equiv-i : is-fiberwise-equiv i
      is-fiberwise-equiv-i = id-fundamental-retr a i retr-i
  in is-equiv-sec-is-equiv (f x) (sec-f x) (is-fiberwise-equiv-i x)

-- Exercise 7.7

is-emb-empty : {i : Level} (A : UU i) → is-emb (ind-empty {P = λ x → A})
is-emb-empty A = ind-empty

-- Exercise 7.8

is-equiv-top-is-equiv-left-square :
  {l1 l2 l3 l4 : Level} {A : UU l1} {B : UU l2} {C : UU l3} {D : UU l4}
  (f : A → B) (g : C → D) (h : A → C) (i : B → D) (H : (i ∘ f) ~ (g ∘ h)) →
  is-equiv i → is-equiv f → is-equiv g → is-equiv h
is-equiv-top-is-equiv-left-square f g h i H Ei Ef Eg =
  is-equiv-right-factor (i ∘ f) g h H Eg
    ( is-equiv-comp (i ∘ f) i f (htpy-refl _) Ef Ei)

is-emb-htpy : {i j : Level} {A : UU i} {B : UU j} (f g : A → B) → (f ~ g) →
  is-emb g → is-emb f
is-emb-htpy f g H is-emb-g x y =
  is-equiv-top-is-equiv-left-square
    ( ap g)
    ( concat' (f y) (H y))
    ( ap f)
    ( concat (g x) (H x))
    ( htpy-nat H)
    ( is-equiv-concat (H x) (g y))
    ( is-emb-g x y)
    ( is-equiv-concat' (f x) (H y))

-- Exercise 7.9

is-emb-comp : {i j k : Level} {A : UU i} {B : UU j} {X : UU k}
  (f : A → X) (g : B → X) (h : A → B) (H : f ~ (g ∘ h)) → is-emb g →
  is-emb h → is-emb f
is-emb-comp f g h H is-emb-g is-emb-h =
  is-emb-htpy f (g ∘ h) H
    ( λ x y → is-equiv-comp (ap (g ∘ h)) (ap g) (ap h) (ap-comp g h)
      ( is-emb-h x y)
      ( is-emb-g (h x) (h y)))

is-emb-right-factor : {i j k : Level} {A : UU i} {B : UU j} {X : UU k}
  (f : A → X) (g : B → X) (h : A → B) (H : f ~ (g ∘ h)) → is-emb g →
  is-emb f → is-emb h
is-emb-right-factor f g h H is-emb-g is-emb-f x y =
  is-equiv-right-factor (ap (g ∘ h)) (ap g) (ap h) (ap-comp g h) (is-emb-g (h x) (h y)) (is-emb-htpy (g ∘ h) f (htpy-inv H) is-emb-f x y )

is-emb-triangle-is-equiv : {i j k : Level} {A : UU i} {B : UU j} {X : UU k}
  (f : A → X) (g : B → X) (e : A → B) (H : f ~ (g ∘ e)) →
  is-equiv e → is-emb g → is-emb f
is-emb-triangle-is-equiv f g e H is-equiv-e is-emb-g =
  is-emb-comp f g e H is-emb-g (is-emb-is-equiv e is-equiv-e)

is-emb-triangle-is-equiv' : {i j k : Level} {A : UU i} {B : UU j} {X : UU k}
  (f : A → X) (g : B → X) (e : A → B) (H : f ~ (g ∘ e)) →
  is-equiv e → is-emb f → is-emb g
is-emb-triangle-is-equiv' f g e H is-equiv-e is-emb-f =
  is-emb-triangle-is-equiv g f
    ( inv-is-equiv is-equiv-e)
    ( triangle-section f g e H
      ( dpair
        ( inv-is-equiv is-equiv-e)
        ( issec-inv-is-equiv is-equiv-e)))
    ( is-equiv-inv-is-equiv is-equiv-e)
    ( is-emb-f)

-- Exercise 7.10
is-emb-sec-ap : {i j : Level} {A : UU i} {B : UU j} (f : A → B) →
  ((x y : A) → sec (ap f {x = x} {y = y})) → is-emb f
is-emb-sec-ap f sec-ap-f x =
  id-fundamental-sec x (λ y → ap f {y = y}) (sec-ap-f x)

-- Exercise 7.12

coherence-reduction-map : {i j : Level} {A : UU i} {B : A → UU j}
  (a : A) (α : (x : A) → B x → Id a x) →
  (Σ (B a) (λ b → Id (α a b) refl)) → Σ A B
coherence-reduction-map a α (dpair b p) = dpair a b

equiv-idtypes-fam-in-id : {i j : Level} {A : UU i} {B : A → UU j}
  (a : A) (α : (x : A) → B x → Id a x) →
  {x : A} (p : Id a x) (b : B x) → (Id (α a (tr B (inv p) b)) refl) ≃ (Id (α x b) p)
equiv-idtypes-fam-in-id a α refl b = dpair id (is-equiv-id (Id (α a b) refl))

is-contr-coherence-reduction-map : {i j : Level} {A : UU i} {B : A → UU j}
  (a : A) (α : (x : A) → B x → Id a x) →
  is-contr-map (coherence-reduction-map a α)
is-contr-coherence-reduction-map {i} {j} {A} {B} a α (dpair x y) =
  is-contr-is-equiv
    ( Σ (B a)
      ( λ b → Σ (Id (α a b) refl)
        ( λ p → Id (coherence-reduction-map a α (dpair b p)) (dpair x y))))
    ( Σ-assoc
      ( B a)
      ( λ y → Id (α a y) refl)
      ( λ z → Id (coherence-reduction-map a α z) (dpair x y)))
    ( is-equiv-Σ-assoc _ _ _)
    ( is-contr-is-equiv
      ( Σ (B a)
        ( λ b → Σ (Id (α a b) refl)
          ( λ p → Σ (Id a x)
            ( λ q → Id (tr B q b) y))))
      {!!} {!!} {!!})

coherence-introduction-map : {i j : Level} {A : UU i} {B : A → UU j}
  (a : A) (α : (x : A) → B x → Id a x) →
  (Σ A B) → (Σ (B a) (λ b → Id (α a b) refl))
coherence-introduction-map a α (dpair x y) =
  dpair
    ( tr _ (inv (α x y)) y)
    ( concat
      ( concat x (α x y) (inv (α x y)))
      ( concat refl (eqv-map (equiv-idtypes-fam-in-id a α refl (tr _ (inv (α x y)) y)) {!!}) (inv (right-inv (α x y))))
      ( right-inv (α x y)))

right-inverse-coherence-introduction-map :
  {i j : Level} {A : UU i} {B : A → UU j}
  (a : A) (α : (x : A) → B x → Id a x) →
  ((coherence-reduction-map a α) ∘ (coherence-introduction-map a α)) ~ id
right-inverse-coherence-introduction-map a α (dpair x y) =
  inv (lift (inv (α x y)) y)

left-inverse-coherence-introduction-map :
  {i j : Level} {A : UU i} {B : A → UU j}
  (a : A) (α : (x : A) → B x → Id a x) →
  ((coherence-introduction-map a α) ∘ (coherence-reduction-map a α)) ~ id
left-inverse-coherence-introduction-map {i} {j} {A} {B} a α (dpair b p) = {!!}

\end{code}

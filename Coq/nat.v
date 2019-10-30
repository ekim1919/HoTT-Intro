Require Export pi.

Inductive NN : Type :=
| zero : NN
| succ : NN -> NN.

Fixpoint add_NN (m n : NN) :=
  match n with
  | zero => m
  | succ n => succ (add_NN m n)
  end.

Fixpoint mul_NN (m n : NN) : NN :=
  match n with
  | zero => zero
  | succ n => add_NN m (mul_NN m n)
  end.

Fixpoint fibonacci (n : NN) : NN :=
  match n with 
  | zero => zero
  | succ Sn =>
    match Sn with
    | zero => succ zero
    | succ m => add_NN (fibonacci Sn) (fibonacci m) 
    end
  end.

Fixpoint factorial (n : NN) : NN :=
  match n with
  | zero => succ zero
  | succ n => mul_NN (factorial n) (succ n)
  end.

Fixpoint power (m n : NN) : NN :=
  match m with
  | zero => succ zero
  | succ m => mul_NN n (power m n)
  end.

Eval compute in fibonacci (succ (succ (succ (succ (succ (succ zero)))))).
                                

Eval compute in mul_NN (succ (succ zero)) (succ (succ zero)).

Inductive Id {A} (a : A) : A -> Type :=
| refl : Id a a.

Lemma inv {A} {x y : A} (p : Id x y) : Id y x.
Proof.
  destruct p.
  apply refl.
Defined.

Lemma concat {A} {x y z : A} (p : Id x y) (q : Id y z) : Id x z.
Proof.
  destruct p.
  assumption.
Defined.

Lemma ap {A B} (f : A -> B) {x y : A} (p : Id x y) : Id (f x) (f y).
Proof.
  destruct p.
  apply refl.
Defined.

Definition left_unit_law_add_NN (n : NN) : Id (add_NN zero n) n.
Proof.
  induction n.
  - apply refl.
  - cbn. now apply ap.
Defined.

Definition right_unit_law_add_NN (n : NN) : Id (add_NN n zero) n.
Proof.
  reflexivity.
Defined.

Definition left_successor_law_add_NN (m n : NN) :
  Id (add_NN (succ m) n) (succ (add_NN m n)).
Proof.
  induction n.
  - reflexivity.
  - apply (ap succ). assumption.
Defined.

Definition right_successor_law_add_NN (m n : NN) :
  Id (add_NN m (succ n)) (succ (add_NN m n)).
Proof.
  reflexivity.
Defined.

Fixpoint associative_add_NN (m n k : NN) :
  Id (add_NN (add_NN m n) k) (add_NN m (add_NN n k)) :=
  match k with
  | zero => refl _
  | succ k => ap succ (associative_add_NN m n k)
  end.

Definition commutative_add_NN (m n : NN) :
  Id (add_NN m n) (add_NN n m).
Proof.
  induction n as [|n commutative_add_NN_m_n].
  - apply inv.
    apply left_unit_law_add_NN.
  - eapply concat.
    * exact (ap succ commutative_add_NN_m_n).
    * apply inv. apply left_successor_law_add_NN.
Defined.
  
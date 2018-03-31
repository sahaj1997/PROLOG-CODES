
:- dynamic(barred_reg/1).
:- dynamic(student/1).
:- dynamic(gradesheet_withheld/1).
:- dynamic(i_ingradesheet/1).
:- dynamic(fee_dues/1).

can_attend_classes(X) :- 
			sem_reg_eligibility(X);
			late_sem_reg_eligibility(X).

sem_reg_eligibility(X) :- 
			student(X),
			\+barred_reg(X),
			\+gradesheet_withheld(X),
			\+i_ingradesheet(X),
			\+fee_dues(X),
			format('~w can register for this semester',[X]).

reg_loc(X) :-
			can_attend_classes(X),
			write('What location are you doing the registraion?'),
			nl,
			write('Enter pilani or offcampus'),
			nl,
			(
			write('If you choose offcampus then enter offcam here.'),	
			read(Y),
			off_campus(Y);
			write('If you choose pilani then enter pilani here.'),
			read(Y),
			on_campus(Y)).

late_sem_reg_eligibility(X) :- 
			(student(X),
			\+week(X),
			write('Do you have the permission of Dean ARC ?'),
			nl,
			write('Type y/n'),
			read(Y),
            check_yes(Y),
			\+barred_reg(X),
			\+gradesheet_withheld(X),
			\+i_ingradesheet(X),
			\+fee_dues(X),
			format('~w can register for this semester',[X]));
			
			(student(X),
			week(X),
			write('Do you have the permission of Dean Instruction ?'),
			nl,
			write('Type y/n'),
			read(Y),
            check_yes(Y),
			\+barred_reg(X),
			\+gradesheet_withheld(X),
			\+i_ingradesheet(X),
			\+fee_dues(X),
			format('~w can register for this semester',[X])).

register_electives(X) :-
			student(X),
			pre_req(X),
			\+over_prep(X),
			\+under_prep(X),
			\+want_cdc_other(X),
			\+higher_degree(X).

higher_degree(X) :- 
			(student_single_degree(X), 
			year(X, Year,Branch),
			courses_done(X, Y),
			trans(Branch, Year,A),
			sub(A,Y));
			(student_dual_degree(X),
			year(X, Branch1,Branch2,Year),
			courses_done(X, Y),
			trans(Branch1, Year, Tra_b1),
			sub(Tra_b1, Y),
			Year_minus1 is Year-1,
			Year > 2,
			trans(Branch2, Year_minus1, Tra_b2),
			sub(Tra_b2, Y)).

core_course(X) :-
			trans_comp(X), 
	(
		(student_dual_degree(X), student(X, _, _, Year), Year>2);
	(student_single_degree(X), student(X, _, Year), Year>1)).


trans_comp(X) :- 
			(single_degree(X),
			year(X,Year,Major),
			courses_done(X,Y),
			trans(Major,Year,A),
			sub(A,Y));
			(dual_degree(X),
			year(X,Year,Minor,Major),
			courses_done(X,Y),
			trans(Major,Year,A),
			trans(Minor,Year,A),
			sub(A,Y)).

ps1_reg_eligibility(X) :-
			sem_reg_eligibility(X),
			courses_done(X,Y),
			\+member_of(ps1,Y),
			trans_comp(X).

ps2_reg_eligibility(X) :-
			sem_reg_eligibility(X),
			courses_done(X,Y),	
			\+member_of(ps2,Y),
			trans_comp(X).

course_clash(X) :-
			\+pre_req(X),
			\+trans_comp(X).

register_course(X) :-
			pre_req(X).

pre_req(X) :-
			(single_degree(X),
			year(X,Year,Major),
			courses_done(X,Y),
			trans(Major,Year,A),
			pre_req1(X,Y));
			(dual_degree(X),
			year(X,Year,Minor,Major),
			courses_done(X,Y),
			trans(Major,Year,A),
			trans(Minor,Year,A),
			pre_req1(X,Y)).


pre_req1(X,[]) :- end_of_file.

pre_req1(X,[A|C]) :- 
			courses_done(X,Y),
			pre_req_sub(A,B),
			sub(B,Y).

on_campus(Y) :-
			Y = pilani.
off_campus(Y) :-
			Y = off.

member_of(X, [X|Xs]).

member_of(X, [Y|Ys]) :-
    		member_of(X, Ys).

sub( [], _ ).

sub( [X|XS], [X|XSS] ) :- 
			sub( XS, XSS ).

sub( [X|XS], [_|XSS] ) :- 
			sub( [X|XS], XSS ).


single_degree(X) :- year(X, _, _).

dual_degree(X)   :- year(X, _, _, _).


check_yes(Y) :-
			Y= y.

year(X,Year,Major).
year(X,Year,Minor,Major).
year(random,2,b3,a7).
student(sahaj).

student(random).
nc(random1).
barred_reg(random1).
gradesheet_withheld(random1).
i_ingradesheet(random1).
fee_dues(random1).
week(random1).

trans(_,1,A) :- A = [first_year].
trans(a7,2,A) :- A = [first_year,disco,m3,lcs,dd].
trans(a4,2,A) :- A = [first_year,mech_sol,flu_mech,thermo].
trans(b1,2,A) :- A = [first_year,bio_chem,bio_fuel].
trans(b3,2,A) :- A = [first_year,chem_l,chem_cou].
trans(a7,3,A) :- A = [first_year,disco,m3,lcs,dd,ps1,dat_min,mac_lear].
trans(a4,3,A) :- A = [first_year,mech_sol,flu_mech,thermo,ps1,thermo_adv,eng_des].
trans(a7,4,A) :- A = [first_year,disco,m3,lcs,dd,ps1,dat_min,mac_lear,ps2].
trans(a4,4,A) :- A = [first_year,mech_sol,flu_mech,thermo,ps1,thermo_adv,eng_des,ps2].
trans(b1,4,A) :- A = [first_year,bio_chem,bio_fuel,ps1,plant_physio,plant_trans,bact_ana,bact_pro].
trans(b3,4,A) :- A = [first_year,chem_l,chem_cou,ps1,chem_fac,chem_enu,chem_eng,chem_dai].
trans(b1,5,A) :- A = [first_year,bio_chem,bio_fuel,ps1,plant_physio,plant_trans,bact_ana,bact_pro,ps2].
trans(b3,5,A) :- A = [first_year,chem_l,chem_cou,ps1,chem_fac,chem_enu,chem_eng,chem_dai,ps2].

pre_req_sub(dd,A) :-   A =[first_year].
pre_req_sub(lcs,A) :-  A =[first_year].
pre_req_sub(m3,A) :-   A =[first_year].
pre_req_sub(disco,A) :-  A =[first_year].
pre_req_sub(dat_min,A) :-  A =[first_year,lcs,disco].
pre_req_sub(mac_lear,A) :-  A =[first_year,dd,disco,lcs].

courses_done(random,Y) :- Y = [first_year,chem_l,chem_cou,ps1,chem_fac,chem_enu,ps1].
student(aditya, a7, 2).
student(keshav, ab, 2).
student(vivek, b4, a7, 2).
student(rohan, b1, ab, 3).
student(hiresh, a7, 3).

student_single_degree(X) :- student(X, _, _).
student_dual_degree(X) :- student(X, _, _, _).

courses_done(aditya, Z) :- Z = [first_year_courses, m3, disco, logic, dsa, dms, mass_comm].
courses_done(keshav, Z) :- Z = [first_year_courses, m3, mech_sol, app_t, linguistics].
courses_done(vivek, Z) :- Z = [first_year_courses, m3, algebra1, dm].
courses_done(rohan, Z) :- Z = [first_year_courses, m3, second_year_bio, ps1, mech_sol, app_t].
courses_done(hiresh, Z) :- Z = [first_year_courses, m3, disco, logic, dsa, dms, ps1, theory_comp].

dues_paid(aditya).
dues_paid(keshav).
dues_paid(vivek).
dues_paid(hiresh).

semback(vivek).
incomplete_report(vivek).
gradesheet_withheld(vivek).

sem_reg_eligibility(X) :- dues_paid(X), \+semback(X), \+incomplete_report(X), \+gradesheet_withheld(X).

ps1_reg_eligibility(X) :- sem_reg_eligibility(X), courses_done(X, Z), \+member_of(ps1, Z), transcript_complete(X).

transcript_complete(X) :- 
	(student_single_degree(X), student(X, Branch, Year), courses_done(X, Y), transcript(Branch, Year, Z), sublist(Z, Y));
	(student_dual_degree(X), student(X, Branch1, Branch2, Year), courses_done(X, Y), transcript(Branch1, Year, Z), sublist(Z, Y)).

member_of(X, [X|Xs]).
member_of(X, [Y|Ys]) :-
    member_of(X, Ys).

transcript(_, 1, Z) :- Z = [first_year_courses].
transcript(a7, 2, Z) :- Z = [first_year_courses, m3, disco, logic, dsa, dms].
transcript(ab, 2, Z) :- Z = [first_year_courses, m3, mech_sol, app_t].
transcript(b4, 2, Z) :- Z = [first_year_courses, m3, algebra1].
transcript(b1, 3, Z) :- Z = [first_year_courses, m3, second_year_bio, third_year_bio].
transcript(b1, 2, Z) :- Z = [first_year_courses, m3, second_year_bio].
transcript(a7, 3, Z) :- Z = [first_year_courses, m3, disco, logic, dsa, dms, theory_comp].

sublist( [], _ ).
sublist( [X|XS], [X|XSS] ) :- sublist( XS, XSS ).
sublist( [X|XS], [_|XSS] ) :- sublist( [X|XS], XSS ).

higher_degree_eligibility(X) :- 
	(student_single_degree(X), student(X, Branch, Year), courses_done(X, Y), transcript(Branch, Year, Z), sublist(Z, Y));
	(student_dual_degree(X), student(X, Branch1, Branch2, Year), courses_done(X, Y), transcript(Branch1, Year, Trans_branch1), sublist(Trans_branch1, Y), Year_minus1 is Year-1, Year > 2, transcript(Branch2, Year_minus1, Trans_branch2), sublist(Trans_branch2, Y)).

core_course_eligibility(X) :-
	transcript_complete(X), 
	((student_dual_degree(X), student(X, _, _, Year), Year>2);
	(student_single_degree(X), student(X, _, Year), Year>1)).

time_of_course(X, Z) :- (X = dsa, Z = 4) ; (X = dms, Z = 5) ; (X = mech_sol, Z = 5) ; (X = app_t, Z = 5) ; (X = theory_comp, Z = 4) ; (X = m3, Z = 3); (X = algebra1, Z = 4); (X = third_year_bio, Z = 2).

course_crash(X) :-
	hour_list(X, ListOfHours), check_list(ListOfHours).

hour_list(X, ListOfHours) :-
	findall(Time, ((student(X, Branch, Year) ; student(X, Branch, Branch2, Year)), transcript(Branch, Year, Courses_currentyear), Year_minus1 is Year-1, transcript(Branch, Year_minus1, Courses_previousyear), time_of_course(Course, Time), subtract(Courses_currentyear, Courses_previousyear, Z), member_of(Course, Z)), ListOfHours).

check_list(L) :- 
	\+sublist([1,1], L), \+sublist([2,2], L), \+sublist([3,3], L), \+sublist([4,4], L), \+sublist([5,5], L).
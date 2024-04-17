// module is_less_than(isLT, A, B, subOut, overflow);
//     //if A >= 0 {A[31] == 0}, if overflow then 0, else subOut[31]
//     //if A < 0, we need to check B.
//     // if B >= 0, LT == 1 (even)
//     // if B <= 0, 

//     //check overflow ? data_operandA[31] : See below;
//     //if A >= 0, subOut[31]
//     //if B >= 0, return 1
//     //if A, B, < 0:
//     //smaller = (bothNegative & (diff[31] | (A[31] & ~B[31]))) | AisNegative | (BisNegative & ~diff[31]);
//     wire bothNegative, AisNegative, BisNegative, notB, notA, w1, w2, w3, w4;
//     and AND1(bothNegative, A[31], B[31]);
//     not NOT1(notA, A);
//     not NOT2(notB, B);
//     and AND2(AisNegative, A[31], notB[31]);
//     and AND3(BisNegative, B[31], notA[31]);
//     or OR1(w1, A[31]
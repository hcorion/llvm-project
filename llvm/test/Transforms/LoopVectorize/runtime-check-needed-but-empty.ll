; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=4 -S %s | FileCheck %s

define void @test(float* %A, i32 %x) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[IDENT_CHECK:%.*]] = icmp ne i32 [[X:%.*]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = or i1 false, [[IDENT_CHECK]]
; CHECK-NEXT:    [[MUL:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 1, i32 undef)
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i32, i1 } [[MUL]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i32, i1 } [[MUL]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP2:%.*]] = sub i32 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt i32 [[TMP2]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ult i32 [[TMP1]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = select i1 false, i1 [[TMP3]], i1 [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = or i1 [[TMP5]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    [[TMP7:%.*]] = or i1 [[TMP0]], [[TMP6]]
; CHECK-NEXT:    [[MUL1:%.*]] = call { i32, i1 } @llvm.umul.with.overflow.i32(i32 1, i32 undef)
; CHECK-NEXT:    [[MUL_RESULT2:%.*]] = extractvalue { i32, i1 } [[MUL1]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW3:%.*]] = extractvalue { i32, i1 } [[MUL1]], 1
; CHECK-NEXT:    [[TMP8:%.*]] = add i32 1, [[MUL_RESULT2]]
; CHECK-NEXT:    [[TMP9:%.*]] = sub i32 1, [[MUL_RESULT2]]
; CHECK-NEXT:    [[TMP10:%.*]] = icmp ugt i32 [[TMP9]], 1
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ult i32 [[TMP8]], 1
; CHECK-NEXT:    [[TMP12:%.*]] = select i1 false, i1 [[TMP10]], i1 [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = or i1 [[TMP12]], [[MUL_OVERFLOW3]]
; CHECK-NEXT:    [[TMP14:%.*]] = or i1 [[TMP7]], [[TMP13]]
; CHECK-NEXT:    br i1 [[TMP14]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i64> undef, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i64> [[BROADCAST_SPLATINSERT]], <4 x i64> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <4 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1, i64 2, i64 3>
; CHECK-NEXT:    [[TMP15:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP16:%.*]] = add nuw nsw i64 [[TMP15]], 1
; CHECK-NEXT:    [[TMP17:%.*]] = trunc i64 [[TMP16]] to i32
; CHECK-NEXT:    [[TMP18:%.*]] = mul i32 [[TMP17]], [[X]]
; CHECK-NEXT:    [[TMP19:%.*]] = zext i32 [[TMP18]] to i64
; CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[TMP19]]
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds float, float* [[TMP20]], i32 0
; CHECK-NEXT:    [[TMP22:%.*]] = bitcast float* [[TMP21]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP22]], align 4
; CHECK-NEXT:    [[TMP23:%.*]] = trunc i64 [[INDEX]] to i32
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT4:%.*]] = insertelement <4 x i32> undef, i32 [[TMP23]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT5:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT4]], <4 x i32> undef, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION6:%.*]] = add <4 x i32> [[BROADCAST_SPLAT5]], <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP24:%.*]] = add i32 [[TMP23]], 0
; CHECK-NEXT:    [[TMP25:%.*]] = mul i32 [[TMP24]], [[X]]
; CHECK-NEXT:    [[TMP26:%.*]] = zext i32 [[TMP25]] to i64
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[TMP26]]
; CHECK-NEXT:    [[TMP28:%.*]] = getelementptr inbounds float, float* [[TMP27]], i32 0
; CHECK-NEXT:    [[TMP29:%.*]] = bitcast float* [[TMP28]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[WIDE_LOAD]], <4 x float>* [[TMP29]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP30:%.*]] = icmp eq i64 [[INDEX_NEXT]], undef
; CHECK-NEXT:    br i1 [[TMP30]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 undef, undef
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ undef, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[IV_NEXT:%.*]], [[LOOP]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[T_IV_NEXT:%.*]] = trunc i64 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[MUL_IV_NEXT:%.*]] = mul i32 [[T_IV_NEXT]], [[X]]
; CHECK-NEXT:    [[IDX_1:%.*]] = zext i32 [[MUL_IV_NEXT]] to i64
; CHECK-NEXT:    [[ARRAYIDX1215:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[IDX_1]]
; CHECK-NEXT:    [[LV:%.*]] = load float, float* [[ARRAYIDX1215]], align 4
; CHECK-NEXT:    [[T_IV:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[MUL_IV:%.*]] = mul i32 [[T_IV]], [[X]]
; CHECK-NEXT:    [[IDX_2:%.*]] = zext i32 [[MUL_IV]] to i64
; CHECK-NEXT:    [[ARRAYIDX1209:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[IDX_2]]
; CHECK-NEXT:    store float [[LV]], float* [[ARRAYIDX1209]], align 4
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i64 [[IV_NEXT]], undef
; CHECK-NEXT:    br i1 [[EC]], label [[EXIT]], label [[LOOP]], !llvm.loop !2
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                     ; preds = %loop, %entry
  %iv = phi i64 [ %iv.next, %loop ], [ 0, %entry ]
  %iv.next = add nuw nsw i64 %iv, 1
  %t.iv.next = trunc i64 %iv.next to i32
  %mul.iv.next = mul i32 %t.iv.next, %x
  %idx.1 = zext i32 %mul.iv.next to i64
  %arrayidx1215 = getelementptr inbounds float, float* %A, i64 %idx.1
  %lv = load float, float* %arrayidx1215, align 4

  %t.iv = trunc i64 %iv to i32
  %mul.iv = mul i32 %t.iv, %x
  %idx.2 = zext i32 %mul.iv to i64
  %arrayidx1209 = getelementptr inbounds float, float* %A, i64 %idx.2
  store float %lv, float* %arrayidx1209, align 4
  %ec = icmp eq i64 %iv.next, undef
  br i1 %ec, label %exit, label %loop

exit:                             ; preds = %loop
  ret void
}
package com.hzgc.service.dispatch.param;

import lombok.Data;

import java.util.List;

@Data
public class WarnHistoryVO {

    private List<DispatchRecognizeVO> dispatchRecognizeVOS;

    private int total;

}

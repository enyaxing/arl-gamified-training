import numpy as np
from math import sin,sqrt
print("TT")
#print(response_values)
def calc(response_values,response):
    pre_cnt, pro_cnt = 0, 0

    B = np.array([1.565563, -0.502494, -0.112472, -6.720915, -2.630483, 1.413550, 0.676953, 0.641702, 0.282040])

    T = 0.677422
    print(response_values)
    for j in range(len(response_values)):
        if(response[j] == 0):
            if j in [0,1,3,5,7,8,10]:
                response_values[j] = 6
            if j in [0,2,6,8,9,10]:
                pre_cnt+=1
            else:
                pro_cnt+=1

    print(pre_cnt, pro_cnt)

    if(pre_cnt == 6):
        pre = 3.0
    else:
        pre = ((6-response_values[0]) + response_values[2] + response_values[6] + (6-response_values[8]) + response_values[9] + (6-response_values[10])) / (6 - pre_cnt)

    if(pro_cnt == 5):
        pro = 3.6
    else:
        pro = ((6-response_values[1]) + (6-response_values[3]) + response_values[4] + (6-response_values[5]) + (6-response_values[7])) / (5 - pro_cnt)

    MSE = 0.953010
    print(pre, pro)

    iCovX = np.array([
    [    0.8873,   -0.0740,   -0.1814,   -0.8873,   -0.8873,    0.0740,    0.1814,    0.0740,    0.1814],
    [   -0.0740,    0.0494,   -0.0166,    0.0740,    0.0740,   -0.0494,    0.0166,   -0.0494,    0.0166],
    [   -0.1814,   -0.0166,    0.0627,    0.1814,    0.1814,    0.0166,   -0.0627,    0.0166,   -0.0627],
    [   -0.8873,    0.0740,    0.1814,    3.9430,    0.8873,   -0.3611,   -0.7339,   -0.0740,   -0.1814],
    [   -0.8873,    0.0740,    0.1814,    0.8873,    2.7615,   -0.0740,   -0.1814,   -0.3327,   -0.4982],
    [    0.0740,   -0.0494,    0.0166,   -0.3611,   -0.0740,    0.1104,    0.0048,    0.0494,   -0.0166],
    [    0.1814,    0.0166,   -0.0627,   -0.7339,   -0.1814,    0.0048,    0.1923,   -0.0166,    0.0627],
    [    0.0740,   -0.0494,    0.0166,   -0.0740,   -0.3327,    0.0494,   -0.0166,    0.1119,    0.0068],
    [    0.1814,   0.0166 ,   -0.0627,   -0.1814,   -0.4982,   -0.0166,    0.0627,    0.0068,    0.1342 ]])

    #print(iCovX)
     
    scores = np.zeros((3,3))

    #gain case 1
    X0 = np.array([1, pre, pro, 0, 1, 0, 0, pre, pro]) #L=0, G=1
    temp = T*sqrt(MSE*(1+np.matmul(X0.transpose(), np.matmul(iCovX, X0))))
    scores[0][0] = np.matmul(X0.transpose(), B)
    scores[0][1] = scores[0][0] - temp
    scores[0][2] = scores[0][0] + temp

    #loss case 2
    X0 = np.array([1, pre, pro, 1, 0, pre, pro, 0, 0]) #L=1, G=0
    temp = T*sqrt(MSE*(1+np.matmul(X0.transpose(), np.matmul(iCovX, X0))))
    scores[1][0] = np.matmul(X0.transpose(), B)
    scores[1][1] = scores[1][0] - temp
    scores[1][2] = scores[1][0] + temp

    #control case 3
    X0 = np.array([1, pre, pro, 0, 0, 0, 0, 0, 0]) #L=0, G=0
    temp = T*sqrt(MSE*(1+np.matmul(X0.transpose(), np.matmul(iCovX, X0))))
    scores[2][0] = np.matmul(X0.transpose(), B)
    scores[2][1] = scores[2][0] - temp
    scores[2][2] = scores[2][0] + temp

    return scores

    #print(calc([6,6,0,6,0,6,0,6,6,0,6]))

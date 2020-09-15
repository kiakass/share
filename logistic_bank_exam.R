## Ch07.로지스틱 회귀분석

# 유니버설 은행 개인대출제안 수라  사례 Figure 9.9 ####
# Ch06.의사결정나무 2 에서 가져오기
# 전처리


# 01.데이터 불러오기
bank.df <- read.csv("bank.csv", 
                    header=TRUE, 
                    na.strings = ".")
bank.df <- bank.df[, -c(1)]

# 02.훈련용, 검증용 데이터 분리
set.seed(2) # 시드 고정 
train.index <- sample(c(1:dim(bank.df)[1]), 
                      dim(bank.df)[1]*0.6)  
train.df <- bank.df[train.index, ]
valid.df <- bank.df[-train.index, ]
head(train.df)

# 03.로지스틱 회귀분석 실행
# glm() : family = "binomial"
logit.reg <- glm(Y ~ ., #train.df$Personal.Loan
                 data = train.df, 
                 family = "binomial")  #binomial: logistic
options(scipen=10) # 소숫점 아래 확인 
summary(logit.reg)

# Odds 계산
odds <- data.frame(summary(logit.reg)$coefficients, 
           odds = exp(coef(logit.reg))) 

round(odds, 5)


# 04.예측모델 확인
# glm 모델에서 predict() 사용법
# type = "response" 예측모델 확률 계산 
logit.reg.pred <- predict(logit.reg, 
                          valid.df[, -8], 
                          type = "response")
head(logit.reg.pred)


# 05.실제값과 예측모델을 통해서 구한 값을 묶어서 데이터 프레임으로 저장
# Table 10.3 실제값 중에서 5개만 화면에 보여줌
data.frame(actual = valid.df$Personal.Loan[1:5], 
           predicted = logit.reg.pred[1:5])


# 06.모델평가
library(caret) #모델성능평가 (ConfusionMatrx)
pred <- predict(logit.reg, valid.df)
confusionMatrix(as.factor(ifelse(pred > 0.5, 1, 0)), # cut off = 0.5
                as.factor(valid.df$Personal.Loan))

# 07.gain chart 만들기
# Figure 10.3

library(gains)
gain <- gains(valid.df$Personal.Loan, 
              logit.reg.pred, 
              groups=10)


# lift chart
plot(c(0,gain$cume.pct.of.total*sum(valid.df$Personal.Loan)) ~ 
       c(0,gain$cume.obs),
     xlab="# cases", 
     ylab="Cumulative", 
     main="", type="l")

lines(c(0,sum(valid.df$Personal.Loan)) ~ 
        c(0, dim(valid.df)[1]), lty=2)



# 10분위 차트 
heights <- gain$mean.resp/mean(valid.df$Personal.Loan)
midpoints <- barplot(heights, 
                     names.arg = gain$depth, 
                     ylim = c(0,9), 
                     xlab = "Percentile", 
                     ylab = "Mean Response", 
                     main = "Decile-wise lift chart")

# 라벨추가
text(midpoints, 
     heights+0.5, 
     labels=round(heights, 1), 
     cex = 0.8)


# 08.중요한 변수 선택
logit.reg1 <- step(logit.reg, 
                   direction = "backward", 
                   trace = F) # 건바이건, F:결과만보여줘
options(scipen=10) # 소숫점 아래 확인 
summary(logit.reg1)






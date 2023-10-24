library(ggplot2)

# Read in the files
prs <- read.table("SLK.0.001.profile", header = TRUE)
sex <- read.table("SLK.cov", header = TRUE)

bmi <- read.table("SLK.bmi", header = TRUE)
sbp <- read.table("SLK.sbp", header = TRUE)
dbp <- read.table("SLK.dbp", header = TRUE)
tc <- read.table("SLK.tc", header = TRUE)
tg <- read.table("SLK.tg", header = TRUE)
glu <- read.table("SLK.glu", header = TRUE)
hdl <- read.table("SLK.hdl", header = TRUE)
ldl <- read.table("SLK.ldl", header = TRUE)

# Rename the sex
sex$SEX <- as.factor(sex$SEX)
levels(sex$SEX) <- c("Male", "Female")

# Merge the files
dat_bmi <- merge(merge(prs, bmi), sex)
dat_sbp <- merge(merge(prs, sbp), sex)
dat_dbp <- merge(merge(prs, dbp), sex)
dat_tc <- merge(merge(prs, tc), sex)
dat_tg <- merge(merge(prs, tg), sex)
dat_glu <- merge(merge(prs, glu), sex)
dat_hdl <- merge(merge(prs, hdl), sex)
dat_ldl <- merge(merge(prs, ldl), sex)

# Start plotting
ggplot(dat_bmi, aes(x = SCORE, y = BMI, color = SEX)) + 
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "BMI")
ggsave("SLK.bmi.scatter.png", height = 7, width = 7)

ggplot(dat_sbp, aes(x = SCORE, y = SBP, color = SEX)) +
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "SBP")
ggsave("SLK.sbp.scatter.png", height = 7, width = 7)

ggplot(dat_dbp, aes(x = SCORE, y = DBP, color = SEX)) +
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "DBP")
ggsave("SLK.dbp.scatter.png", height = 7, width = 7)

ggplot(dat_tc, aes(x = SCORE, y = Cholesterol, color = SEX)) +
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "Cholesterol")
ggsave("SLK.tc.scatter.png", height = 7, width = 7)

ggplot(dat_tg, aes(x = SCORE, y = Triglyceride, color = SEX)) +
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "Triglyceride")
ggsave("SLK.tg.scatter.png", height = 7, width = 7)

ggplot(dat_glu, aes(x = SCORE, y = Glucose, color = SEX)) +
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "Fasting Glucose")
ggsave("SLK.glu.scatter.png", height = 7, width = 7)

ggplot(dat_hdl, aes(x = SCORE, y = HDL, color = SEX)) +
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "HDL")
ggsave("SLK.hdl.scatter.png", height = 7, width = 7)

ggplot(dat_ldl, aes(x = SCORE, y = LDL, color = SEX)) +
  geom_point() +
  theme_classic() +
  labs(x = "BMI Polygenic Score", y = "LDL")
ggsave("SLK.ldl.scatter.png", height = 7, width = 7)

# Calculate the correlation and p-value
correlation_test_bmi <- cor.test(dat_bmi$SCORE, dat_bmi$BMI)
correlation_test_sbp <- cor.test(dat_sbp$SCORE, dat_sbp$SBP)
correlation_test_dbp <- cor.test(dat_dbp$SCORE, dat_dbp$DBP)
correlation_test_tc <- cor.test(dat_tc$SCORE, dat_tc$Cholesterol)
correlation_test_tg <- cor.test(dat_tg$SCORE, dat_tg$Triglyceride)
correlation_test_glu <- cor.test(dat_glu$SCORE, dat_glu$Glucose)
correlation_test_hdl <- cor.test(dat_hdl$SCORE, dat_hdl$HDL)
correlation_test_ldl <- cor.test(dat_ldl$SCORE, dat_ldl$LDL)

# Print the correlation and p-value
cat("Correlation_BMI:\n", correlation_test_bmi$estimate, "\n", "P-value_BMI:\n", correlation_test_bmi$p.value, "\n")
cat("Correlation_SBP:\n", correlation_test_sbp$estimate, "\n", "P-value_SBP:\n", correlation_test_sbp$p.value, "\n")
cat("Correlation_DBP:\n", correlation_test_dbp$estimate, "\n", "P-value_DBP:\n", correlation_test_dbp$p.value, "\n")
cat("Correlation_Cholesterol:\n", correlation_test_tc$estimate, "\n", "P-value_Cholesterol:\n", correlation_test_tc$p.value, "\n")
cat("Correlation_Triglyceride:\n", correlation_test_tg$estimate, "\n", "P-value_Triglyceride:\n", correlation_test_tg$p.value, "\n")
cat("Correlation_Glucose:\n", correlation_test_glu$estimate, "\n", "P-value_Glucose:\n", correlation_test_glu$p.value, "\n")
cat("Correlation_HDL:\n", correlation_test_hdl$estimate, "\n", "P-value_HDL:\n", correlation_test_hdl$p.value, "\n")
cat("Correlation_LDL:\n", correlation_test_ldl$estimate, "\n", "P-value_LDL:\n", correlation_test_ldl$p.value, "\n")

# Calculate deciles of BMI PRS
dat_bmi$Deciles <- with(dat_bmi, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))
dat_sbp$Deciles <- with(dat_sbp, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))
dat_dbp$Deciles <- with(dat_dbp, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))
dat_tc$Deciles <- with(dat_tc, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))
dat_tg$Deciles <- with(dat_tg, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))
dat_glu$Deciles <- with(dat_glu, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))
dat_hdl$Deciles <- with(dat_hdl, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))
dat_ldl$Deciles <- with(dat_ldl, cut(SCORE, breaks = quantile(SCORE, probs = seq(0, 1, by = 0.1)), include.lowest = TRUE, labels = FALSE))

# Create a boxplot
ggplot(dat_bmi, aes(x = factor(Deciles), y = BMI)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "BMI")
ggsave("SLK.bmi.boxplot.png", height = 7, width = 7)

ggplot(dat_sbp, aes(x = factor(Deciles), y = SBP)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "SBP")
ggsave("SLK.sbp.boxplot.png", height = 7, width = 7)

ggplot(dat_dbp, aes(x = factor(Deciles), y = DBP)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "DBP")
ggsave("SLK.dbp.boxplot.png", height = 7, width = 7)

ggplot(dat_tc, aes(x = factor(Deciles), y = Cholesterol)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "Cholesterol")
ggsave("SLK.tc.boxplot.png", height = 7, width = 7)

ggplot(dat_tg, aes(x = factor(Deciles), y = Triglyceride)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "Triglyceride")
ggsave("SLK.tg.boxplot.png", height = 7, width = 7)

ggplot(dat_glu, aes(x = factor(Deciles), y = Glucose)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "Fasting Glucose")
ggsave("SLK.glu.boxplot.png", height = 7, width = 7)

ggplot(dat_hdl, aes(x = factor(Deciles), y = HDL)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "HDL")
ggsave("SLK.hdl.boxplot.png", height = 7, width = 7)

ggplot(dat_ldl, aes(x = factor(Deciles), y = LDL)) +
  geom_boxplot() +
  theme_classic() +
  labs(x = "BMI PRS Deciles", y = "LDL")
ggsave("SLK.ldl.boxplot.png", height = 7, width = 7)

library(data.table)
library(magrittr)
p.threshold <- c(0.001,0.005,0.01,0.05,0.1,0.2,0.3,0.4,0.5)
phenotype <- fread("SLK.bmi")
pcs <- fread("SLK.eigenvec", header=F) %>%
    setnames(., colnames(.), c("FID", "IID", paste0("PC",1:6)) )
covariate <- fread("SLK.cov")
pheno <- merge(phenotype, covariate) %>%
        merge(., pcs)
null.r2 <- summary(lm(BMI~., data = pheno[, -c("FID", "IID")]))$r.squared

prs.result <- NULL

for(i in p.threshold){
    pheno.prs <- paste0("SLK.", i, ".profile") %>%
        fread(.) %>%
        .[,c("FID", "IID", "SCORE")] %>%
        merge(., pheno, by=c("FID", "IID"))

    model <- lm(BMI~., data=pheno.prs[,-c("FID","IID")]) %>%
            summary
    model.r2 <- model$r.squared
    prs.r2 <- model.r2-null.r2
    prs.coef <- model$coeff["SCORE",]
    prs.result %<>% rbind(.,
        data.frame(Threshold=i, R2=prs.r2, 
                    P=as.numeric(prs.coef[4]), 
                    BETA=as.numeric(prs.coef[1]),
                    SE=as.numeric(prs.coef[2])))
}

print(prs.result[which.max(prs.result$R2),])
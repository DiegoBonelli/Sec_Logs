
GetList=function(link="https://www.sec.gov/files/EDGAR_LogFileData_thru_Jun2017.html"){
List=readLines(link)
List=as.data.frame(List)
List=as.data.table(List[10:(dim(List)[1]-2),])
List=List[,V1:=gsub(" ", "", V1, fixed = TRUE)]
List=List[,V1:=paste0("https://",V1)]
List=List[,year:=as.numeric(substr(V1,58,61))]
List=List[,qrt:=as.numeric(substr(V1,66,66))]
List=List[,month:=as.numeric(substr(V1,75,76))]

return(List)
}

DownloadOneLog=function(Link){
temp <- tempfile()
  # temp=file.path(getwd(),FolderDownload)
  # setwd(temp)
  # temp=paste(temp,paste0(substr(Link,nchar(Link)-14,nchar(Link)-4),".csv"),sep="/")
  # temp=gsub("/","\\\\",temp)
# Download zip
download.file(as.character(Link),temp,quiet = T) 
# Get files
zipdf <- unzip(temp, list = TRUE)
# Get the csv file
csv_file <- zipdf$Name[which(substr(zipdf$Name, nchar(zipdf$Name)-2, nchar(zipdf$Name))=="csv")]
# Read file
file <- fread(unzip(temp, files = csv_file))
unlink(csv_file, recursive = TRUE)
unlink(temp)
return(file)
}

DownloadOneYear=function(List,Year,cl=8,overwrite=F,format="RData",out_RData=out_RData,
                         out_csv=out_csv,FolderDownload=raw_filings_folder){
  # out_RData=paste0(getwd(),"/",out_RData)
  # out_csv=paste0(getwd(),"/",out_csv)
  
  ListYear=List[year==Year]
  ListYear$year=NULL
  # save a file each qrt
  for(i in 1:4){
    Listqrt=ListYear[qrt==i]
    Listqrt$qrt=NULL
    Listqrt$month=NULL
    # if overwrite = TRUE, replace all files
    if(overwrite == TRUE) {
      Listqrt=Listqrt
    } else {
      if(format=="csv"){
      if(file.exists(paste(out_csv,paste0("Log_",Year,"_Qrt",i,".csv"),sep="/"))==T){
        Listqrt=NULL
      }}
      if(format=="RData"){
        if(file.exists(paste(out_RData,paste0("Log_",Year,"_Qrt",i,".RData"),sep="/"))==T){
          Listqrt=NULL
        }}
      }
    
    if(length(Listqrt) > 0) { 
  Log=plyr::rbind.fill(pbapply(Listqrt,1,FUN=DownloadOneLog,cl=cl))
  if(format=="csv"){
    fwrite(Log,file=paste(out_csv,paste0("Log_",Year,"_Qrt",i,".csv"),sep="/"),nThread=getDTthreads())
  }
  if(format=="RData"){
    save(Log,file=(paste(out_RData,paste0("Log_",Year,"_Qrt",i,".Rdata"),sep="/")))
  }
  
  if(format=="all"){
    save(Log,file=(paste(out_RData,paste0("Log_",Year,"_Qrt",i,".Rdata"),sep="/")))
    fwrite(Log,file=paste(out_csv,paste0("Log_",Year,"_Qrt",i,".csv"),sep="/")
          ,nThread=getDTthreads())
}
    }
    
    }}
  



DownloadAll=function(Link="https://www.sec.gov/files/EDGAR_LogFileData_thru_Jun2017.html",
                     cl=8,format="RData",out_csv=out_csv,out_RData=out_RData){
  out_RData=paste0(getwd(),"/",out_RData)
  out_csv=paste0(getwd(),"/",out_csv)
  
  List=GetList(Link)
  BeginY=min(List$year)
  EndY=max(List$year)
  for (i in BeginY:EndY) {
    cat(i)
    DownloadOneYear(List = List,Year=i,cl=cl,format=format,out_csv=out_csv,out_RData=out_RData)
  }}



DownloadOneYearMonthly=function(List,Year,cl=8,overwrite=F,format="RData",out_RData=out_RData,
                         out_csv=out_csv,FolderDownload=raw_filings_folder){
  # out_RData=paste0(getwd(),"/",out_RData)
  # out_csv=paste0(getwd(),"/",out_csv)
  
  ListYear=List[year==Year]
  ListYear$year=NULL
  # save a file each qrt
  for(i in 1:12){
    Listqrt=ListYear[month==i]
    Listqrt$month=NULL
    Listqrt$qrt=NULL
    
    # if overwrite = TRUE, replace all files
    if(overwrite == TRUE) {
      Listqrt=Listqrt
    } else {
      if(format=="csv"){
        if(file.exists(paste(out_csv,paste0("Log_",Year,"_Month_",i,".csv"),sep="/"))==T){
          Listqrt=NULL
        }}
      if(format=="RData"){
        if(file.exists(paste(out_RData,paste0("Log_",Year,"_Month_",i,".RData"),sep="/"))==T){
          Listqrt=NULL
        }}
    }
    
    if(length(Listqrt) > 0) { 
      Log=plyr::rbind.fill(pbapply(Listqrt,1,FUN=DownloadOneLog,cl=cl))
      if(format=="csv"){
        fwrite(Log,file=paste(out_csv,paste0("Log_",Year,"_Month_",i,".csv"),sep="/"),nThread=getDTthreads())
      }
      if(format=="RData"){
        save(Log,file=(paste(out_RData,paste0("Log_",Year,"_Month_",i,".Rdata"),sep="/")))
      }
      
      if(format=="all"){
        save(Log,file=(paste(out_RData,paste0("Log_",Year,"_Month_",i,".Rdata"),sep="/")))
        fwrite(Log,file=paste(out_csv,paste0("Log_",Year,"_Month_",i,".csv"),sep="/")
               ,nThread=getDTthreads())
      }
    }
    
  }}




DownloadAllMonthly=function(Link="https://www.sec.gov/files/EDGAR_LogFileData_thru_Jun2017.html",
                     cl=8,format="RData",out_csv=out_csv,out_RData=out_RData){
  out_RData=paste0(getwd(),"/",out_RData)
  out_csv=paste0(getwd(),"/",out_csv)
  
  List=GetList(Link)
  BeginY=min(List$year)
  EndY=max(List$year)
  for (i in BeginY:EndY) {
    cat(i)
    DownloadOneYearMonthly(List = List,Year=i,cl=cl,format=format,out_csv=out_csv,out_RData=out_RData)
  }}






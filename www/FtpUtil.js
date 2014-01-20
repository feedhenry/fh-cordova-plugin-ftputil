function FtpUtil(){

}

FtpUtil.prototype.list = function(successCallback, errorCallback, options){
  cordova.exec(successCallback, errorCallback, "FtpUtil", "ftplist", [options]);
}

cordova.addConstructor(function() {
                        
    if(!window.plugins)        {
        window.plugins = {};
    }
        
    window.plugins.ftputil = new FtpUtil();
});
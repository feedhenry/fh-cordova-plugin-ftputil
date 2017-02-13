var exec = require('cordova/exec');

function FtpUtil(){

}

FtpUtil.prototype.list = function(successCallback, errorCallback, options){
  exec(successCallback, errorCallback, "FtpUtil", "ftplist", [options]);
}

module.exports = new FtpUtil();
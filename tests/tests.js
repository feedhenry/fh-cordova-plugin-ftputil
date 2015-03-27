/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

exports.defineAutoTests = function () {
  describe('API test', function () {
    it("FtpUtil should exist", function () {
      expect(window.plugins.ftputil).toBeDefined();
      expect(typeof window.plugins.ftputil == 'object').toBe(true);
    });

    it("should contain a list function", function () {
      expect(window.plugins.ftputil.list).toBeDefined();
      expect(typeof window.plugins.ftputil.list == 'function').toBe(true);
    });
  });
};

exports.defineManualTests = function (contentEl, createActionButton) {
  var logMessage = function (message, color) {
    var log = document.getElementById('info');
    var logLine = document.createElement('div');
    if (color) {
      logLine.style.color = color;
    }
    logLine.innerHTML = message;
    log.appendChild(logLine);
  }

  var clearLog = function () {
    var log = document.getElementById('info');
    log.innerHTML = '';
  }

  var html = '<h3>Fetch list from ftp server</h3>' +
    '<div id="output"></div>' +
    '<input type="test" id="url" value="ftp://ftp.nluug.nl/"/><br/>' +
    'Expected result: Status box will show list of files on ftp server';

  contentEl.innerHTML = '<div id="info"></div>' + html;

  createActionButton('Fetch list', function () {
    clearLog();
    var url = document.getElementById('url').value;
    window.plugins.ftputil.list(
      function (files) {
        var length = files.length;
        for (var i = 0; i < length; i++) {
          logMessage(files[i].name + ' ' + files[i].timestamp);
        }
      },
      function (err) {
        logMessage('Error ' + err, 'red');
      }, {
        "url": url
      });
  }, "output");
};
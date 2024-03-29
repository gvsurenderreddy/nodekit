/*
 * Copyright 2015 Domabo; Portions Copyright 2014 Red Hat
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"use strict";

var _delegate;

switch(process.platform) {
    case 'darwin':
        _delegate = require('./_delegates/tcp/_darwin_tcp_wrap.js');
        break;
    case 'win32':
        _delegate = require('./_delegates/tcp/_winrt_tcp_wrap.js');
        break;
    default:
        _delegate = require('./_delegates/tcp/_browser_tcp_wrap.js');
        break;
}

exports.TCP = _delegate.TCP;

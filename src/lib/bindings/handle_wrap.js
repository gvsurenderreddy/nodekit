/*
 * Copyright 2015 Domabo.  Portions Copyright 2014 Red Hat, Inc.
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

function Handle(handle) {
    this._handle = handle;
}

Handle.prototype.ref = function() {
};

Handle.prototype.unref = function() {
};

Handle.prototype.close = function(callback) {
    if (this._handle) {
    this._handle.close();
    this._handle = null;
    }
    if ( callback ) {
        callback.call( this );
    }
};

module.exports.Handle = Handle;

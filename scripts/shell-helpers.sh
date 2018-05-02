#!/bin/bash

#        Copyright Abdessattar Sassi 2018.
#    Distributed under the 3-Clause BSD License.
#    (See accompanying file LICENSE or copy at
#   https://opensource.org/licenses/BSD-3-Clause)

shw_grey() {
    echo -e $(tput setaf 7)"$@"$(tput sgr 0)
}

shw_norm() {
    echo -e $(tput bold)$(tput setaf 7)"$@"$(tput sgr 0)
}

shw_info() {
    echo -e $(tput bold)$(tput setaf 4)"$@"$(tput sgr 0)
}

shw_warn() {
    echo -e $(tput bold)$(tput setaf 3)"$@"$(tput sgr 0)
}

shw_err() {
    echo -e $(tput bold)$(tput setaf 1)"$@"$(tput sgr 0)
}

asis_warn_msg="$(fold -s <(echo 'THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.'))"

confirm() {
    read -r -p "${1:-Continue? {y/N]}" response
    case "$response" in
    [yY][eE][sS] | [yY])
        true
        ;;
    *)
        false
        ;;
    esac
}

asis_warn() {
    shw_warn "$asis_warn_msg"
    echo -e
    shw_warn "You should read the scripts and KNOW WHAT YOU ARE DOING."
    confirm || { exit 1; }
}

check_enable_service() {
    [ -z "$1" ] && return
    systemctl is-enabled $1 >/dev/null || (shw_grey "Enabling $1" && sudo systemctl enable $1)
}

check_start_service() {
    [ -z "$1" ] && return
    systemctl is-active $1 >/dev/null || (shw_grey "Starting $1" && sudo systemctl start $1)
}

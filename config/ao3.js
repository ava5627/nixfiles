// ==UserScript==
// @name        AO3: Kudosed and seen history
// @description Highlight or hide works you kudosed/marked as seen.
// @namespace   https://greasyfork.org/scripts/5835-ao3-kudosed-and-seen-history
// @author	Min/ava
// @version	3.2.0
// @history	2.2.1 - fix for bookmarked blurbs
// @history	2.2 - separate kudosed and seen settings, smaller icons
// @history	2.1 - fix for reversi
// @history	2.0 - rewrite, click actions for blurbs, new highlighting
// @history	1.5 - import/export seen list
// @history	1.4 - thinner stripes, remembers bookmarks you left
// @history	1.3 - option to collapse blurbs of seen works
// @history	1.2.1 - double click on date marks work as seen
// @history	1.2 - check for bookmarks you left, changes to the menu
// @grant       none
// @require     https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js
// @include     http://*archiveofourown.org/*
// @include     https://*archiveofourown.org/*
// ==/UserScript==


(function($) {

    var DEBUG = false;

    // newest more-or-less major version, for the update notice
    var current_version = '3.02';

    var kudos_history = {}, seen_buttons = {}, saved_settings = {};
    var main = $('#main');

    // check if reversi
    var body_bg_color = window.getComputedStyle(document.body).backgroundColor;
    if (body_bg_color == 'rgb(51, 51, 51)') {
        main.addClass('kh-reversi');
    }

    // uncomment the next five lines if you need to clear your local lists (then comment them again after refreshing the page once)
    // localStorage.removeItem('kudoshistory_kudosed');
    // localStorage.removeItem('kudoshistory_checked');
    // localStorage.removeItem('kudoshistory_seen');
    // localStorage.removeItem('kudoshistory_bookmarked');
    // localStorage.removeItem('kudoshistory_skipped');
    var KHDict = {
        init: function init(name, max_length) {
            this.name = name;
            this.max_length = max_length || 200000;
            var list_str = localStorage.getItem('kudoshistory_' + this.name) || '{}';
            this.list = JSON.parse(list_str);
            return this;
        },

        reload: function reload() {
            var list_str = localStorage.getItem('kudoshistory_' + this.name) || this.list;
            this.list = JSON.parse(list_str);
            return this;
        },
        save: function save() {
            try {
                var list_str = JSON.stringify(this.list);
                localStorage.setItem('kudoshistory_' + this.name, list_str);
            }
            catch (e) {
                console.log('Error saving ' + this.name + ' list: ' + e);
                alert('Error saving ' + this.name + ' list: ' + e);
            }
            return this;
        },
        hasId: function hasId(work_id) {
            if (parseInt(work_id) in this.list) {
                return this.list[work_id];
            }
            else {
                return false;
            }
        },
        add: function add(work_id, chapter) {
            chapter = chapter || 1;
            work_id = parseInt(work_id);
            if (!isNaN(work_id)) {
                this.list[work_id] = chapter;
            }
            return this;
        },
        remove: function remove(work_id) {
            work_id = parseInt(work_id);
            if (!isNaN(work_id) && work_id in this.list) {
                delete this.list[work_id];
            }
            return this;
        },
    };

    var KHList = {
        init: function init(name, max_length) {
            this.name = name;
            this.max_length = max_length || 200000;
            var list_str = localStorage.getItem('kudoshistory_' + this.name) || '[]';
            if (list_str[0] === '{') {
                // if it's a dictionary, convert it to an array
                list_str = list_str.replace(/^{/, '[').replace(/}$/, ']').replace(/:\d+/g, "").replace(/"/g, "");
            }
            this.list = JSON.parse(list_str);
            return this;
        },

        reload: function reload() {
            var list_str = localStorage.getItem('kudoshistory_' + this.name) || this.list;
            if (list_str[0] === '{') {
                // if it's a dictionary, convert it to an array
                list_str = list_str.replace(/^{/, '[').replace(/}$/, ']').replace(/:\d+/g, "").replace(/"/g, "");
            }
            this.list = JSON.parse(list_str);
            return this;
        },
        save: function save() {
            try {
                var list_str = JSON.stringify(this.list);
                localStorage.setItem('kudoshistory_' + this.name, list_str);
            }
            catch (e) {
                console.log('Error saving ' + this.name + ' list: ' + e);
                alert('Error saving ' + this.name + ' list: ' + e);
            }
            return this;
        },
        hasId: function hasId(work_id) {
            work_id = parseInt(work_id);
            return this.list.includes(work_id);
        },
        add: function add(work_id) {
            work_id = parseInt(work_id);
            if (!isNaN(work_id) && !this.hasId(work_id)) {
                this.list.push(work_id);
            }
            if (this.list.length > this.max_length) {
                this.list.shift(); // remove the oldest item if the list is too long
            }
            return this;
        },
        remove: function remove(work_id) {
            work_id = parseInt(work_id);
            if (!isNaN(work_id)) {
                var index = this.list.indexOf(work_id);
                if (index > -1) {
                    this.list.splice(index, 1);
                }
            }
            return this;
        },
    };

    var KHSetting = {
        init: function init(setting) {
            this.name = setting.name;
            this.label = setting.label;
            this.description = setting.description;
            this.options = setting.options;
            this.current = saved_settings[this.name] || setting.default_value;
            return this;
        },

        next: function next() {
            this.current = this.options[this.options.indexOf(this.current) + 1] || this.options[0];
            this.updateButton();
            this.save();
            addMainClass(true);
        },
        getButton: function getButton() {
            this.button_link = $('<a></a>').text(this.label + ': ' + this.current.toUpperCase()).prop('title', this.options.join(' / ').toUpperCase());
            this.button = $('<li class="kh-menu-setting"></li>').append(this.button_link);
            var this_setting = this;
            this.button.click(function() {
                this_setting.next();
            });
            return this.button;
        },
        updateButton: function updateButton() {
            this.button_link.text(this.label + ': ' + this.current.toUpperCase());
        },
        changeValue: function changeValue(value) {
            this.current = value;
            this.updateButton();
            this.updateSettingRow();
            this.save();
            addMainClass(true);
        },
        getSettingRow: function getSettingRow() {
            var setting_row_info = $('<p class="kh-setting-info kh-hide-element">' + this.description + '</p>');
            var setting_row_info_button = $('<a class="help symbol question kh-setting-info-button"><span class="symbol question"><span>?</span></span></a>');
            var setting_row_label = $('<span class="kh-setting-label">' + this.label + ': </span>').append(setting_row_info_button);
            this.setting_row_options = $('<span class="kh-setting-options"></span>');
            this.setting_row = $('<p class="kh-setting-row"></p>').append(setting_row_label, this.setting_row_options, setting_row_info);
            this.updateSettingRow();
            setting_row_info_button.click(function() {
                setting_row_info.toggleClass('kh-hide-element');
            });
            return this.setting_row;
        },
        updateSettingRow: function updateSettingRow() {
            var this_setting = this;
            this_setting.setting_row_options.empty();
            this.options.forEach(function(option) {
                var option_link = $('<a class="kh-setting-option"></a>');
                option_link.click(function() {
                    this_setting.changeValue(option);
                });

                if (this_setting.current == option) {
                    option_link.html('<strong>' + option.toUpperCase() + '</strong>').addClass('kh-setting-option-selected');
                }
                else {
                    option_link.text(option.toUpperCase());
                }

                this_setting.setting_row_options.append(' ', option_link, ' <span class="kh-setting-separator">&bull;</span>');
            });
        },
        save: function save() {
            saved_settings[this.name] = this.current;
            localStorage.setItem('kudoshistory_settings', JSON.stringify(saved_settings));
        },
        check: function check(compare) {
            return (this.current === (compare || 'yes'));
        },
    };

    var settings_list = [
        {
            name: 'kudosed_display',
            label: 'Kudosed works',
            description: 'Hide the works on lists, show the whole blurb, or show just the blurb header.',
            options: ['hide', 'show', 'collapse'],
            default_value: 'collapse',
        },
        {
            name: 'seen_display',
            label: 'Seen works',
            description: 'Hide the works on lists, show the whole blurb, or show just the blurb header.',
            options: ['hide', 'show', 'collapse'],
            default_value: 'collapse',
        },
        {
            name: 'skipped_display',
            label: 'Skipped works',
            description: 'Hide the works on lists, replace the blurb content with "Skipped", or show just the blurb header.',
            options: ['hide', 'placeholder', 'collapse'],
            default_value: 'placeholder',
        },
        {
            name: 'toggles_display',
            label: 'Blurb options',
            description: 'The controls on top right of the blurb that let you mark/unmark the work as seen or skipped from the list.',
            options: ['hide', 'show', 'on hover'],
            default_value: 'on hover',
        },
        {
            name: 'highlight_bookmarked',
            label: 'Highlight bookmarked',
            description: 'Show a striped stripe (yeah) on the right for works you\'ve bookmarked.',
            options: ['yes', 'no'],
            default_value: 'yes',
        },
        {
            name: 'highlight_new',
            label: 'Highlight new',
            description: 'Show a thin coloured stripe on the left of the blurb for works you\'re seeing for the first time. Only shows on the lists.',
            options: ['yes', 'no'],
            default_value: 'yes',
        },
        {
            name: 'autoseen',
            label: 'Mark as seen on open',
            description: 'Automatically mark as seen when you open the work page.',
            options: ['yes', 'no'],
            default_value: 'no',
        },
        {
            name: 'background_check',
            label: 'Check for kudos while browsing works lists',
            description: 'The script checks kudos on the works in the background. <strong>Warning:</strong> This may cause too many requests to AO3 if you browse too quickly, and it\'s not very reliable since AO3 started paginating kudos (so the script may not find yours if it\'s further down the list).',
            options: ['yes', 'no'],
            default_value: 'no',
        },
    ];

    if (typeof (Storage) !== 'undefined') {

        saved_settings = JSON.parse(localStorage.getItem('kudoshistory_settings')) || {};

        kudos_history = {
            kudosed: Object.create(KHList).init('kudosed'),
            checked: Object.create(KHList).init('checked'),
            seen: Object.create(KHDict).init('seen', 2000000),
            bookmarked: Object.create(KHList).init('bookmarked'),
            skipped: Object.create(KHList).init('skipped'),

            username: localStorage.getItem('kudoshistory_username'),

            saveLists: function() {
                DEBUG && console.log('saving lists');
                this.kudosed.save();
                this.checked.save();
                this.seen.save();
                this.bookmarked.save();
                this.skipped.save();
            },
        };

        settings_list.forEach(function(setting) {
            kudos_history[setting.name] = Object.create(KHSetting).init(setting);
        });

        var userlink = $('#greeting li.dropdown > a[href^="/users/"]');

        if (!kudos_history.username) { localStorage.setItem('kudoshistory_lastver', current_version); }

        // if logged in
        if (userlink.length) {
            var found_username = userlink.attr('href').split('/')[2];
            DEBUG && console.log('found username: ' + found_username);

            if (kudos_history.username !== found_username) {
                kudos_history.username = found_username;
                localStorage.setItem('kudoshistory_username', kudos_history.username);
            }
        }
        // if not logged in, but remembers username
        else if (!!kudos_history.username) {
            DEBUG && console.log("didn't find username on page, saved username: " + kudos_history.username);
        }
        else {
            kudos_history.username = prompt('AO3: Kudosed and seen history\n\nYour AO3 username:');
            localStorage.setItem('kudoshistory_username', kudos_history.username);
        }

        $(document).ajaxStop(function() {
            kudos_history.saveLists();
        });

        // add css rules for kudosed works
        addCss();

        var works_and_bookmarks = $('li.work.blurb, li.bookmark.blurb');

        // if there's a list of works or bookmarks
        if (works_and_bookmarks.length) {
            addSeenMenu();

            var blurb_index = $('.index');

            // click on header to collapse/expand
            blurb_index.on('click', '.header', function(e) {
                if (!$(e.target).is('a') && !$(e.target).is('span')) {
                    $(this).closest('.blurb').toggleClass('collapsed-blurb');
                    e.stopPropagation();
                }
            });

            // toggle seen/skipped
            blurb_index.on('click', '.kh-toggle', function(e) {
                changeBlurbStatus($(this).closest('.blurb'), $(this).data('list'), true);
                e.stopPropagation();
            });

            // click on delete bookmark
            blurb_index.on('click', '.own.user a[data-method="delete"]', function() {
                var work_id = $(this).closest('.blurb').data('work_id');

                if (work_id) {
                    kudos_history.bookmarked.reload().remove(work_id).save();
                }
            });

            // for each work and bookmark blurb
            works_and_bookmarks.not('.deleted').each(function() {
                blurbCheck($(this));
            });
        }

        // if it's the first time after an update
        addNotice();

        // if it's a work page
        if ($('#workskin').length && $('h3.byline a:first').text() != kudos_history.username) {

            var work_meta = $('dl.work.meta.group');

            // get work id
            var work_id = $('#kudo_commentable_id').val();
            DEBUG && console.log('work_id ' + work_id);

            var chapters = $('#chapters>.chapter');
            var chapter = 1;
            if (chapters.length) {
                chapter = chapters[0].id.split('-').pop();
                chapter = parseInt(chapter) || 1;
            }
            DEBUG && console.log('chapter ' + chapter);

            // check if work id is on the seen list
            var is_seen = kudos_history.seen.hasId(work_id);
            var new_seen = false;
            DEBUG && console.log('last seen ' + is_seen);
            if (kudos_history.autoseen.check()) {
                if (!is_seen || parseInt(is_seen) < chapter) {
                    kudos_history.seen.add(work_id, chapter);
                    new_seen = is_seen || "new";
                    is_seen = chapter.toString();
                }
            }


            if (is_seen) {
                work_meta.addClass('marked-seen');
                var latest_chapter = work_meta.find('dd.chapters').html().split("/")[0] || "1";
                latest_chapter = parseInt(latest_chapter);
                if (new_seen) {
                    is_seen = new_seen + " (" + is_seen + "/"+ latest_chapter + ")";
                } else if (parseInt(is_seen) < latest_chapter) {
                    is_seen += ' (' + latest_chapter + ')';
                }
                work_meta.prepend('<div class="seen-chapter">' + is_seen + '</div>');
            }

            addSeenButtons();

            // if work id is on the kudosed list
            if (kudos_history.kudosed.hasId(work_id)) {
                work_meta.addClass('has-kudos');
                DEBUG && console.log('- on kudosed list');
            }
            else {
                // check if there are kudos from the user
                var user_kudos = $('#kudos').find('[href="/users/' + kudos_history.username + '"]');

                if (user_kudos.length) {
                    // highlight blurb and add work id to kudosed list
                    kudos_history.kudosed.add(work_id);
                    kudos_history.checked.remove(work_id);
                    work_meta.addClass('has-kudos');
                }
                else {
                    // add work id to checked list
                    kudos_history.checked.add(work_id);

                    $('#new_kudo').one('click', function() {
                        kudos_history.kudosed.reload().add(work_id).save();
                        kudos_history.checked.reload().remove(work_id).save();
                        work_meta.addClass('has-kudos');
                    });
                }
            }

            // check if it's bookmarked
            var bookmark_button_text = $('a.bookmark_form_placement_open').filter(':first').text();

            if (bookmark_button_text.indexOf('Edit') > -1) {
                // highlight blurb
                kudos_history.bookmarked.add(work_id);
                work_meta.addClass('is-bookmarked');
            }
            else {
                kudos_history.bookmarked.remove(work_id);
            }
        }

        // save all lists
        kudos_history.saveLists();
    }

    // check if work is on lists
    function blurbCheck(blurb) {

        var work_id;
        var blurb_id = blurb.attr('id');

        if (blurb.hasClass('work')) {
            work_id = blurb_id.replace('work_', '');
        }
        else if (blurb.hasClass('bookmark')) {
            var work_link = blurb.find('h4 a:first').attr('href');

            // if it's not a deleted work and not a series or external bookmark
            if (!!work_link && work_link.indexOf('series') === -1 && work_link.indexOf('external_work') === -1) {
                work_id = work_link.split('/').pop();

                // if it's your own bookmark
                var own_bookmark = blurb.find('div.own.user.module.group');
                if (own_bookmark.length) {
                    kudos_history.bookmarked.add(work_id);
                }
            }
        }

        blurb.data('work_id', work_id);

        DEBUG && console.log('blurb check ' + blurb_id + ', work_id: ' + work_id);

        if (!work_id) {
            return false;
        }

        var found_on_list = false;
        var blurb_classes = 'blurb-with-toggles';
        blurb.prepend('<div class="kh-toggles">mark/unmark as: <a class="kh-toggle" data-list="seen">seen</a> &bull; <a class="kh-toggle" data-list="skipped">skipped</a>');

        // if work id is on the kudosed list
        if (kudos_history.kudosed.hasId(work_id)) {
            DEBUG && console.log('- is kudosed');
            blurb_classes += ' has-kudos collapsed-blurb';
            found_on_list = true;
        }


        // if work id is on the seen list
        var seen_chapter = kudos_history.seen.hasId(work_id);
        if (seen_chapter) {
            DEBUG && console.log('- is seen');
            blurb_classes += ' marked-seen collapsed-blurb';
            var chapter_num = blurb.find('dd.chapters > a').html() || "1";
            chapter_num = parseInt(chapter_num);
            if (seen_chapter < chapter_num) {
                seen_chapter = seen_chapter + ' (' + chapter_num + ')';
            }
            blurb.prepend('<div class="seen-chapter">' + seen_chapter + '</div>');
            found_on_list = true;
        }

        // not on the kudosed/seen list
        if (!found_on_list) {

            // if work id is on the checked list
            if (kudos_history.checked.hasId(work_id)) {
                DEBUG && console.log('- is checked');
            }
            else {
                blurb_classes += ' new-blurb';
                if (kudos_history.background_check.check()) {
                    loadKudos(blurb);
                }
                else {
                    DEBUG && console.log('- marking as checked');
                    kudos_history.checked.add(work_id);
                }
            }
        }

        // if work id is on the bookmarked list
        if (kudos_history.bookmarked.hasId(work_id)) {
            DEBUG && console.log('- is bookmarked');
            blurb_classes += ' is-bookmarked';
        }

        // if work id is on the skipped list
        if (kudos_history.skipped.hasId(work_id)) {
            DEBUG && console.log('- is skipped');
            blurb_classes += ' skipped-work collapsed-blurb';
        }

        blurb.addClass(blurb_classes);
    }

    // load kudos for blurb
    function loadKudos(blurb) {

        var work_id = blurb.data('work_id');

        if (!work_id) {
            return false;
        }

        DEBUG && console.log('- loading kudos for ' + work_id);

        // add a div to the blurb that will house the kudos
        var kudos_container = $('<div style="display: none;"></div>');
        blurb.append(kudos_container);

        // retrieve a list of kudos from the work
        var work_url = window.location.protocol + '//' + window.location.hostname + '/works/' + work_id + '/kudos #kudos';
        kudos_container.load(work_url, function() {
            // check if there are kudos from the user
            var user_kudos = kudos_container.find('[href="/users/' + kudos_history.username + '"]');

            if (user_kudos.length) {
                // highlight blurb and add work id to kudosed list
                blurb.addClass('has-kudos collapsed-blurb');
                if (!kudos_history.seen.hasId(work_id)) {
                    var chapter = blurb.find('dd.chapters > a').html() || "1";
                    chapter = parseInt(chapter);
                    kudos_history.seen.add(work_id, chapter);
                }
                kudos_history.kudosed.add(work_id);
            }
            else {
                // add work id to checked list
                kudos_history.checked.add(work_id);
            }
        });
    }

    // mark all works on the page as seen
    function markPageSeen() {

        kudos_history.seen.reload();

        // for each blurb
        works_and_bookmarks.not('.marked-seen').not('.has-kudos').not('.deleted').each(function() {
            changeBlurbStatus($(this), 'seen', false, true);
        });

        kudos_history.seen.save();
    }

    // mark all works on the page as unseen
    function markPageUnseen() {

        kudos_history.seen.reload();

        // for each blurb
        works_and_bookmarks.not('.deleted').each(function() {
            changeBlurbStatus($(this), 'seen', false, false);
        });

        kudos_history.seen.save();
    }

    // mark/unmark blurb as X
    function changeBlurbStatus(blurb, list, save_list, add_to_list) {

        var work_id = blurb.data('work_id');

        if (work_id) {

            save_list && kudos_history[list].reload();

            var blurb_class = {
                seen: 'marked-seen',
                skipped: 'skipped-work'
            };

            if (add_to_list == undefined) {
                add_to_list = !kudos_history[list].hasId(work_id);
            }

            if (add_to_list) {
                var chapter_num = parseInt(blurb.find('dd.chapters > a').html() || "1");
                kudos_history[list].add(work_id, chapter_num);
                DEBUG && console.log('marking as ' + list + ' ' + work_id);
                blurb.addClass(blurb_class[list] + ' collapsed-blurb');
                blurb.find('.seen-chapter').remove();
                blurb.prepend('<div class="seen-chapter">' + chapter_num + '</div>');
            }
            else {
                DEBUG && console.log('unmarking as ' + list + ' ' + work_id);
                kudos_history[list].remove(work_id);
                blurb.removeClass(blurb_class[list]);
            }

            save_list && kudos_history[list].save();
        }
    }

    // re-check the page for kudos
    function recheckKudos() {

        kudos_history.kudosed.reload();
        kudos_history.checked.reload();

        // for each non-kudosed blurb
        works_and_bookmarks.not('.has-kudos').not('.deleted').each(function() {
            loadKudos($(this));
        });
    }

    // check the page for bookmarks
    function checkForBookmarks() {

        kudos_history.bookmarked.reload();

        // for each work and bookmark blurb
        works_and_bookmarks.not('.deleted').each(function() {

            var blurb = $(this);
            var work_id = blurb.data('work_id');

            if (!work_id) {
                return false;
            }

            DEBUG && console.log('- loading bookmark buttons for ' + work_id);

            // add a div to the blurb that will house the kudos
            var bookmark_container = $('<div style="display: none;"></div>');
            blurb.append(bookmark_container);

            // retrieve the bookmark button from the work
            var work_url = window.location.protocol + '//' + window.location.hostname + '/works/' + work_id + ' a.bookmark_form_placement_open:first';
            bookmark_container.load(work_url, function() {
                // check if there is a bookmark from the user
                var bookmark_button_text = bookmark_container.find('a').text();

                if (bookmark_button_text.indexOf('Edit') > -1) {
                    // highlight blurb
                    blurb.addClass('is-bookmarked');
                    kudos_history.bookmarked.add(work_id);
                }
                else {
                    blurb.removeClass('is-bookmarked');
                    kudos_history.bookmarked.remove(work_id);
                }
            });
        });
    }

    // show the box with import/export options
    function importExport() {

        var importexport_bg = $('<div id="importexport-bg"></div>');

        var importexport_box = $('<div id="importexport-box"></div>');

        var box_button_save = $('<input type="button" id="importexport-button-save" value="Import lists" />');
        box_button_save.click(function() {

            var confirmed = confirm('Sure you want to replace your saved lists?');

            if (confirmed) {
                var import_lists = JSON.parse($('#import-seen-list').val());

                for (var list_name in import_lists) {
                    if (kudos_history[list_name]) {
                        kudos_history[list_name].list = import_lists[list_name];
                        kudos_history[list_name].save();
                    }
                }

                $('#importexport-save').prepend('Lists imported! ');
            }
        });

        var box_button_close = $('<input type="button" id="importexport-button-close" value="Close" />');

        var list_types = ['kudosed', 'seen', 'bookmarked', 'skipped', 'checked'];

        var list_types_checkboxes = [];
        list_types.forEach(function(list_type) {
            list_types_checkboxes.push('<label class="kh-export-checkbox-label"><input type="checkbox" id="kh-export-checkbox-' + list_type + '" checked />' + list_type + '</label>');
        });


        var box_button_generate = $('<input type="button" id="importexport-button-generate" value="Generate your export" />');
        box_button_generate.click(function() {
            var export_lists = {};
            list_types.forEach(function(list_type) {
                if ($('#kh-export-checkbox-' + list_type).prop('checked')) {
                    export_lists[list_type] = kudos_history[list_type].reload().list;
                }
            });
            $('#export-seen-list').val(JSON.stringify(export_lists));
        });

        importexport_box.append(
            $('<p class="actions"></p>').append(box_button_close),
            $('<h3></h3>').text('Settings'),
        );

        settings_list.forEach(function(setting) {
            importexport_box.append(kudos_history[setting.name].getSettingRow());
        });

        importexport_box.append(
            $('<h3 style="margin-top: 1.5em;"></h3>').text('Export your saved lists'),
            $('<p></p>').text('Select which lists to export (leave them all selected if you\'re not sure) and generate your export. Then copy your current lists from the field below and save wherever you want as a backup.'),
            $('<p></p>').append(list_types_checkboxes),
            $('<p class="actions" id="importexport-generate"></p>').append(box_button_generate),
            $('<input type="text" id="export-seen-list" class="kh-text-input" />'),
            $('<h3 style="margin-top: 1.5em;"></h3>').text('Import your lists'),
            $('<p></p>').html('Put your saved lists in the field below and select the "Import lists" button. <strong>Warning:</strong> it will <u>replace</u> your current lists.'),
            $('<input type="text" id="import-seen-list" class="kh-text-input" />'),
            $('<p class="actions" id="importexport-save"></p>').append(box_button_save),
        );

        $('body').append(importexport_bg);
        main.append(importexport_box);

        box_button_close.add(importexport_bg).click(function() {
            importexport_box.detach();
            importexport_bg.detach();
        });
    }

    // add the seen/unseen buttons
    function addSeenButtons() {

        seen_buttons = {
            is_seen: is_seen,
            buttons_links: [],

            change: function() {
                DEBUG && console.log(this);
                this.is_seen = !this.is_seen;
                kudos_history.seen.reload();

                if (this.is_seen) {
                    kudos_history.seen.add(work_id);
                    work_meta.addClass('marked-seen');
                }
                else {
                    kudos_history.seen.remove(work_id);
                    work_meta.removeClass('marked-seen');
                }

                kudos_history.seen.save();
                this.updateButtons();
                DEBUG && console.log(this);
            },
            getButton: function() {
                var button_link = $('<a></a>').html(this.is_seen ? 'Unseen &cross;' : 'Seen &check;');
                var button = $('<li class="kh-seen-button"></li>').append(button_link);
                var this_setting = this;
                button.click(function() {
                    this_setting.change();
                });
                this.buttons_links.push(button_link);
                return button;
            },
            updateButtons: function() {
                for (var i = 0; i < this.buttons_links.length; i++) {
                    this.buttons_links[i].html(this.is_seen ? 'Unseen &cross;' : 'Seen &check;');
                }
            },
        };

        $('li.bookmark').after(seen_buttons.getButton());
        $('#new_kudo').parent().after(seen_buttons.getButton());
    }

    // attach the menu
    function addSeenMenu() {

        // create a button for the menu
        function getMenuButton(button_text, on_click) {
            var button = $('<li><a>' + button_text + '</a></li>');
            if (on_click) {
                button.click(on_click);
                button.addClass('kh-menu-setting');
            }
            else {
                button.addClass('kh-menu-header');
            }
            return button;
        }

        // get the header menu
        var header_menu = $('ul.primary.navigation.actions');

        // create menu button
        var seen_menu = $('<li class="dropdown"></li>').html('<a>Seen works</a>');

        // create dropdown menu
        var drop_menu = $('<ul class="menu dropdown-menu"></li>');

        // append buttons to the dropdown menu
        drop_menu.append(
            getMenuButton('Settings and import/export', importExport),
            getMenuButton('&mdash; For all works on this page: &mdash;'),
            getMenuButton('Mark as seen', markPageSeen),
            getMenuButton('Unmark as seen', markPageUnseen),
            getMenuButton('Re-check for kudos', recheckKudos),
            getMenuButton('Check for bookmarks', checkForBookmarks),
            getMenuButton('&mdash; Settings (click to change): &mdash;'),
        );

        settings_list.forEach(function(setting) {
            drop_menu.append(kudos_history[setting.name].getButton());
        });

        seen_menu.append(drop_menu);
        header_menu.find('li.search').before(seen_menu);
    }

    // add a notice about an update
    function addNotice() {

        var last_version = localStorage.getItem('kudoshistory_lastver') || current_version;

        if (last_version < current_version) {

            var update_3_2 = "<h3>version 3.2</h3>\
                <p><b>&bull; Checking the works for kudos in the background while browsing works lists is now disabled by default.</b> It looks like it can do more harm than good these days - it may cause too many requests to AO3 if you browse too quickly, and it's not very reliable since AO3 started paginating kudos (so the script may not find yours if it's further down the list). If you need it, you can turn it back on in settings, or use \"Re-check for kudos\" on the current page.</p>\
                <p><b>&bull; More options for the export.</b> You can pick which lists you want to export.</p>";

            var update_notice = $('<div id="kudoshistory-update" class="notice"></div>');

            update_notice.append("<h3><b>Kudosed and seen history userscript updated!</b></h3>", update_3_2, "<p style='text-align: right;'><b><a id='kudoshistory-hide-update'>Don't show this again</a></b></p>");

            main.prepend(update_notice);

            $('#kudoshistory-hide-update').click(function() {
                localStorage.setItem('kudoshistory_lastver', current_version);
                update_notice.detach();
            });
        }
    }

    // add css rules to page head
    function addCss() {
        var css = '#importexport-box .kh-setting-separator:last-child,.kh-hide-element,.kh-skipped-display-hide .skipped-work,.kh-skipped-display-placeholder .skipped-work>*,.kh-toggles,:not(.marked-seen)>.seen-chapter{display:none}.has-kudos,.has-kudos.marked-seen{background:url("https://i.imgur.com/jK7d4jh.png") left no-repeat,url("https://i.imgur.com/ESdBCSX.png") left repeat-y!important;padding-left:50px!important}.marked-seen{background:url("https://i.imgur.com/ESdBCSX.png") left repeat-y!important;padding-left:50px!important}.marked-seen>.seen-chapter{position:absolute;left:0;top:50%;text-align:center;transform:translateY(-50%);font-weight:700;width:40px;height:100%;align-content:center;color:white;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000}.kh-highlight-bookmarked-yes .is-bookmarked,dl.is-bookmarked{background:url("https://i.imgur.com/qol1mWZ.png") right repeat-y!important;padding-right:50px!important}.kh-highlight-bookmarked-yes .is-bookmarked.has-kudos,.kh-highlight-bookmarked-yes .is-bookmarked.has-kudos.marked-seen,dl.is-bookmarked.has-kudos,dl.is-bookmarked.has-kudos.marked-seen{background:url("https://i.imgur.com/jK7d4jh.png") left no-repeat,url("https://i.imgur.com/ESdBCSX.png") left repeat-y,url("https://i.imgur.com/qol1mWZ.png") right repeat-y!important}.kh-highlight-bookmarked-yes .is-bookmarked.marked-seen,dl.is-bookmarked.marked-seen{background:url("https://i.imgur.com/ESdBCSX.png") left repeat-y,url("https://i.imgur.com/qol1mWZ.png") right repeat-y!important}#kudoshistory-update a,.kh-menu-setting a,.kh-seen-button a,.kh-toggles a{cursor:pointer}.kh-menu-setting a{white-space:normal;height:auto}.kh-menu-header a{padding:.5em .5em .25em!important;text-align:center;font-weight:700}#kudoshistory-update{padding:.5em 1em 1em}#kudoshistory-update img{max-width:300px;height:auto}#importexport-box{position:fixed;top:0;bottom:0;left:0;right:0;width:60%;height:80%;max-width:800px;margin:auto;overflow-y:auto;border:10px solid #eee;box-shadow:0 0 8px 0 rgba(0,0,0,.2);padding:0 20px;background-color:#fff;z-index:999}#importexport-box input[type=button]{height:auto;cursor:pointer}#importexport-box p.actions{float:none;text-align:right}#importexport-box .kh-setting-row{line-height:1.6em}#importexport-box .kh-setting-label{display:inline-block;min-width:13.5em}#importexport-box .kh-setting-label .kh-setting-info-button{font-size:.8em;cursor:pointer}#importexport-box .kh-setting-option{padding:0 3px;border-radius:4px;border:0;color:#111;background:#eee;cursor:pointer}#importexport-box .kh-setting-option.kh-setting-option-selected{color:#fff;background:#900}#importexport-box .kh-setting-info{position:relative;border:1px solid;padding:1px 5px}#importexport-box .kh-setting-info:before{content:" ";position:absolute;top:-12px;border:6px solid transparent;border-bottom-color:initial}#importexport-box .kh-text-input{width:95%}#importexport-box .kh-export-checkbox-label{display:inline-block;cursor:pointer}#importexport-box #importexport-generate,#importexport-box #importexport-save{text-align:left}#importexport-bg{position:fixed;width:100%;height:100%;background-color:#000;opacity:.7;z-index:998}.kh-toggles{position:absolute;top:-22px;font-size:10px;line-height:10px;right:-1px;background:#fff;border:1px solid #ddd;padding:5px}.kh-reversi #importexport-box{background-color:#333;border-color:#222}.kh-reversi #importexport-box .kh-setting-option-selected{background:#5998d6}.kh-reversi .kh-toggles{background:#333;border-color:#555}.kh-highlight-bookmarked-yes .bookmark.is-bookmarked p.status{padding-right:40px}@media screen and (max-width:42em){.has-kudos,.has-kudos.marked-seen,.marked-seen{background-size:20px!important;padding-left:30px!important}.kh-highlight-bookmarked-yes .is-bookmarked,dl.is-bookmarked{background-size:20px!important;padding-right:30px!important}.kh-highlight-bookmarked-yes .is-bookmarked.has-kudos,.kh-highlight-bookmarked-yes .is-bookmarked.has-kudos.marked-seen,.kh-highlight-bookmarked-yes .is-bookmarked.marked-seen,dl.is-bookmarked.has-kudos,dl.is-bookmarked.has-kudos.marked-seen,dl.is-bookmarked.marked-seen{background-size:20px!important}#importexport-box .kh-setting-label{display:block;min-width:auto}.kh-highlight-bookmarked-yes .bookmark.is-bookmarked p.status{padding-right:20px}}.kh-kudosed-display-collapse .collapsed-blurb.has-kudos .header .fandoms.heading,.kh-kudosed-display-collapse .collapsed-blurb.has-kudos blockquote.userstuff.summary,.kh-kudosed-display-collapse .collapsed-blurb.has-kudos dl.stats,.kh-kudosed-display-collapse .collapsed-blurb.has-kudos h6.landmark.heading,.kh-kudosed-display-collapse .collapsed-blurb.has-kudos>ul,.kh-kudosed-display-hide:not(.bookmarks-show) li.has-kudos,.kh-seen-display-collapse .collapsed-blurb.marked-seen .header .fandoms.heading,.kh-seen-display-collapse .collapsed-blurb.marked-seen blockquote.userstuff.summary,.kh-seen-display-collapse .collapsed-blurb.marked-seen dl.stats,.kh-seen-display-collapse .collapsed-blurb.marked-seen h6.landmark.heading,.kh-seen-display-collapse .collapsed-blurb.marked-seen>ul,.kh-seen-display-hide:not(.bookmarks-show) li.marked-seen,.kh-skipped-display-collapse .collapsed-blurb.skipped-work .header .fandoms.heading,.kh-skipped-display-collapse .collapsed-blurb.skipped-work blockquote.userstuff.summary,.kh-skipped-display-collapse .collapsed-blurb.skipped-work dl.stats,.kh-skipped-display-collapse .collapsed-blurb.skipped-work h6.landmark.heading,.kh-skipped-display-collapse .collapsed-blurb.skipped-work>ul{display:none!important}.kh-kudosed-display-collapse .collapsed-blurb.has-kudos .mystery .icon,.kh-kudosed-display-collapse .collapsed-blurb.has-kudos .required-tags,.kh-seen-display-collapse .collapsed-blurb.marked-seen .mystery .icon,.kh-seen-display-collapse .collapsed-blurb.marked-seen .required-tags,.kh-skipped-display-collapse .collapsed-blurb.skipped-work .mystery .icon,.kh-skipped-display-collapse .collapsed-blurb.skipped-work .required-tags{opacity:.6;transform:scale(.4);transform-origin:top left}.kh-kudosed-display-collapse .collapsed-blurb.has-kudos .header,.kh-seen-display-collapse .collapsed-blurb.marked-seen .header,.kh-skipped-display-collapse .collapsed-blurb.skipped-work .header{min-height:22px;cursor:zoom-in}.kh-kudosed-display-collapse .collapsed-blurb.has-kudos .header .heading,.kh-seen-display-collapse .collapsed-blurb.marked-seen .header .heading,.kh-skipped-display-collapse .collapsed-blurb.skipped-work .header .heading{margin-left:32px}.kh-kudosed-display-collapse .has-kudos:not(.collapsed-blurb) .header,.kh-seen-display-collapse .marked-seen:not(.collapsed-blurb) .header,.kh-skipped-display-collapse .skipped-work:not(.collapsed-blurb) .header{cursor:zoom-out}.kh-skipped-display-placeholder .skipped-work:before{content:"Skipped"}.kh-highlight-new-yes li.new-blurb{border-left:5px solid #900}.kh-highlight-new-yes.kh-reversi#main li.new-blurb{border-left-color:#5998d6}.kh-toggles-display-on-hover li.blurb-with-toggles:hover>.kh-toggles,.kh-toggles-display-show li.blurb-with-toggles .kh-toggles{display:block}.kh-toggles-display-show li.blurb-with-toggles{margin-top:31px}';

        var style = $('<style type="text/css"></style>').appendTo($('head'));
        style.html(css);

        addMainClass();
    }

    function addMainClass(update) {

        var classes_to_remove = [];
        var classes_to_add = [];

        settings_list.forEach(function(setting) {
            var setting_class_name = setting.name.replace('_', '-');
            classes_to_add.push('kh-' + setting_class_name + '-' + kudos_history[setting.name].current.replace(' ', '-'));

            if (update) {
                setting.options.forEach(function(option) {
                    classes_to_remove.push('kh-' + setting_class_name + '-' + option.replace(' ', '-'));
                });
            }
        });

        if (update) {
            main.removeClass(classes_to_remove.join(' '));
        }

        main.addClass(classes_to_add.join(' '));
    }
})(jQuery);

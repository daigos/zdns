$(function(){
      var App = function() {
        var app = this;

        // current status
        var current_zone_id = null;
        var current_record_type = "soa";
        var current_record_id = null;
        var current_page_type = null;

        app.getCurrentZone = function() {
          var zone = null;
          try {
            zone = app.Record.data[current_zone_id]["soa"];
          } catch(e) {
            if (app.Zone.data) {
              zone = app.Zone.data[current_zone_id];
            }
          }
          return zone || new app.Zone();
        };

        app.getCurrentAnyRecords = function() {
          return app.Record.data[current_zone_id] || {};
        };

        app.getCurrentRecords = function(record_type) {
          return app.getCurrentAnyRecords()[record_type] || {};
        };

        app.getCurrentRecord = function() {
          var record = app.getCurrentRecords(current_record_type)[current_record_id];
          if (!record) {
            if (current_record_type=="soa") {
              record = new app.Zone();
            } else {
              record = new app.Record(current_record_type);
              record.zone_id = current_zone_id;
            }
          }
          return record;
        };

        // record default data
        var defaults = {
          soa: {
            name: "example.com.",
            ttl: 3600,
            mname: "ns.example.com.",
            rname: "root.example.com.",
            serial: (function(){
              var d = new Date();
              var y = d.getFullYear()*10000;
              var m = (d.getMonth()+1)*100;
              var d = d.getDate();
              return y+m+d+"";
            })(),
            refresh: "14400",
            retry: "3600",
            expire: "604800",
            minimum: "7200"
          },
          a: {
            name: "www",
            ttl: 3600,
            address: "192.168.1.80",
            enable_ptr: true
          },
          ns: {
            name: "@",
            ttl: 3600,
            nsdname: "ns"
          },
          cname: {
            name: "@",
            ttl: 3600,
            cname: "www.example.com."
          },
          mx: {
            name: "@",
            ttl: 3600,
            preference: 10,
            exchange: "mx.example.com."
          },
          txt: {
            name: "@",
            ttl: 3600,
            txt_data: "v=spf1 +ip4:192.168.1.25/32 -all"
          },
          aaaa: {
            name: "@",
            ttl: 3600,
            address: "2001:db8::80",
            enable_ptr: true
          }
        };

        app.recordTypes = function(include_soa, callback) {
          for (var k in defaults) {
            k!="soa" || include_soa ? callback(k) : null;
          };
        };

        app.recordKeys = function(type, callback) {
          for (var k in defaults[type] || {}) {
            callback(k);
          }
        };

        // start application

        app.start = function() {
          app.renderInitialize();

          $(window).bind('hashchange', function() {
            app.dispatch(location.hash);
          });
          app.dispatch(location.hash);
        };

        // routes

        app.dispatch = function(hash) {
          if (m = hash.match(/^#(\d+)(?:\/(soa|a|ns|cname|mx|txt|aaaa))?\/?$/)) {
            // show: zone & record
            // #123 #123/soa
            app.actionShow("show", m[1], m[2]);
          } else if (m = hash.match(/^#(?:soa\/)new\/?$/)) {
            // new zone
            // #new
            app.actionShow("new");
          } else if (m = hash.match(/^#(\d+)\/(a|ns|cname|mx|txt|aaaa)\/new\/?$/)) {
            // new: records
            // #123/a/new
            app.actionShow("new", m[1], m[2]);
          } else if (m = hash.match(/^#(\d+)(?:\/soa)?\/edit\/?$/)) {
            // edit zone
            // #123/edit
            app.actionShow("edit", m[1]);
          } else if (m = hash.match(/^#(\d+)\/(a|ns|cname|mx|txt|aaaa)\/(\d+)\/edit\/?$/)) {
            // edit: records
            // #123/a/123/edit
            app.actionShow("edit", m[1], m[2], m[3]);
          } else {
            app.actionRoot();
          }
        };

        // controller

        app.actionShow = function(page_type, zone_id, record_type, record_id) {
          current_page_type = page_type;
          zone_id = parseInt(zone_id);
          current_record_type = record_type || "soa";
          current_record_id = record_id;

          // zone
          app.Zone.load(function(is_renew){
            if (is_renew) {
              app.refrectZones();
              app.renderZones();
            }
          });

          // records
          app.renderLoading();
          app.Record.load(zone_id, function(changed) {
            if (changed) {
              app.refrectRecords();
            }
            app.refrectRecord();
            app.renderRecords();
          });

          // navigation
          app.renderNavView();
        };

        app.actionRoot = function() {
          app.Zone.load(function(is_renew){
            if (is_renew) {
              app.refrectZones();
            }

            // select first zone
            var zone_id = 0;
            for (var id in app.Zone.data) {
              zone_id = id;
              break;
            }
            app.actionShow("show", zone_id);
          });
        }

        // model

        app.Zone = function(params) {
          var record = this;
          record.params = {};

          record.isNew = function() {
            return !record.id;
          };

          record.setParams = function(params) {
            params = params || {};

            record.id = params["id"];
            delete params["id"];

            for (var k in params) {
              record.params[k] = params[k];
            }
          };

          record.save = function(callback) {
            var method = "POST";
            var url = null;
            if (record.isNew()) {
              // new
              method = "POST";
              url = "/api/zone";
            } else {
              // update
              method = "PUT";
              url = "/api/zone/"+record.id;
            }

            // request
            $.ajax({
              url: url,
              type: method,
              contentType: "application/json",
              data: JSON.stringify(record.params),
              dataType: 'json',
              success: function(ret) {
                record.setParams(ret);
                app.Zone.data[record.id] = record;
                if (callback) {
                  callback(true, ret);
                }
              },
              error: function(ret) {
                if (callback) {
                  callback(false, JSON.parse(ret));
                }
              }
            });
          };

          record.destroy = function(callback) {
            if (!record.isNew()) {
              var method = "DELETE";
              var url = "/api/zone/"+record.id;

              // request
              $.ajax({
                url: url,
                type: method,
                dataType: 'json',
                success: function(ret) {
                  delete app.Zone.data[record.id];
                  delete app.Record.data[record.id];
                  record.id = null;
                  if (callback) {
                    callback(true, ret);
                  }
                },
                error: function(ret) {
                  if (callback) {
                    callback(false, JSON.parse(ret));
                  }
                }
              });
            } else {
              if (callback) {
                callback(false, {message: "Zone is not saved"});
              }
            }
          };

          record.moveShowPage = function() {
            location.hash = "#"+record.id;
          };
          record.moveNewPage = function() {
            location.hash = "#soa/new";
          };
          record.moveEditPage = function() {
            location.hash = "#"+record.id+"/soa/edit";
          };

          // instance

          record.type = "soa";
          record.setParams(params);
        };

        app.Zone.data = null;
        app.Zone.load = function(callback) {
          if (!app.Zone.data) {
            // ajax
            $.getJSON("/api/zone", function(json){
              var data = {}
              for (var i=0; i<json.length; i++) {
                var zone = new app.Zone(json[i]);
                data[zone.id] = zone;
              }
              app.Zone.data = data;
              if (callback) {
                callback(true);
              }
            });
          } else {
            // use cache
            if (callback) {
              callback(false);
            }
          }
        };

        app.Record = function(type, params) {
          var record = this;
          record.id = null;
          record.zone_id = null;
          record.params = {};

          record.isNew = function() {
            return !record.id;
          };

          record.setParams = function(params) {
            params = params || {};

            record.id = params["id"];
            delete params["id"];

            record.zone_id = params["soa_record_id"];
            delete params["soa_record_id"];

            for (var k in params) {
              record.params[k] = params[k];
            }
          };

          record.save = function(callback) {
            var url = null;
            var method = null;

            if (record.isNew()) {
              // new
              method = "POST";
              url = "/api/zone/"+record.zone_id+"/"+record.type;
            } else {
              // edit
              method = "PUT";
              url = "/api/zone/"+record.zone_id+"/"+record.type+"/"+record.id;
            }

            // request
            $.ajax({
              url: url,
              type: method,
              contentType: "application/json",
              data: JSON.stringify(record.params),
              dataType: 'json',
              success: function(ret) {
                console.log("success");
                var is_new = record.isNew();
                record.setParams(ret);
                if (is_new) {
                  app.Record.data[record.zone_id][record.type][record.id] = record;
                }

                if (callback) {
                  callback(true, ret);
                }
              },
              error: function(ret) {
                if (callback) {
                  callback(false, JSON.parse(ret));
                }
              }
            });
          };

          record.destroy = function(callback) {
            if (!record.isNew()) {
              var method = "DELETE";
              var url = "/api/zone/"+record.zone_id+"/"+record.type+"/"+record.id;

              // request
              $.ajax({
                url: url,
                type: method,
                dataType: 'json',
                success: function(ret) {
                  delete app.Record.data[record.zone_id][record.type][record.id];
                  record.id = null;
                  if (callback) {
                    callback(true, ret);
                  }
                },
                error: function(ret) {
                  if (callback) {
                    callback(false, JSON.parse(ret));
                  }
                }
              });
            } else {
              if (callback) {
                callback(false, {message: "Record is not saved"});
              }
            }
          };

          record.moveShowPage = function() {
            location.hash = "#"+record.zone_id+"/"+record.type;
          };
          record.moveNewPage = function() {
            location.hash = "#"+record.zone_id+"/"+record.type+"/new";
          };
          record.moveEditPage = function() {
            location.hash = "#"+record.zone_id+"/"+record.type+"/"+record.id+"/edit";
          };

          // instance

          record.type = type || "a";
          record.setParams(params);
        };

        app.Record.data = {};
        app.Record.load = function(zone_id, callback) {
          var changed = current_zone_id!=zone_id;
          current_zone_id = zone_id;

          if (zone_id && !app.Record.data[zone_id]) {
            // ajax
            $.getJSON("/api/zone/"+zone_id+"/any", function(json){
              var data = {};
              for (var type in json) {
                if (type=="soa") {
                  data[type] = new app.Zone(json[type]);
                } else {
                  data[type] = {};
                  for (var i=0; i<json[type].length; i++) {
                    var record = new app.Record(type, json[type][i]);
                    data[type][record.id] = record;
                  }
                }
              }
              app.Record.data[zone_id] = data;

              if (callback) {
                callback(changed);
              }
            });
          } else {
            // use cache
            if (callback) {
              callback(changed);
            }
          }
        };

        // view refrect (dom)

        app.refrectZones = function() {
          var list = $("#zonelist");
          list.empty();
          for (var id in app.Zone.data) {
            var zone = app.Zone.data[id];
            var item = $("<a/>")
              .attr("href", "#"+zone.id)
              .attr("title", zone.params["name"])
              .text(zone.params["name"]);
            item = $("<li/>").addClass("zone"+zone.id).append(item);
            list.append(item);
          };
        };

        app.refrectRecords = function() {
          var zone = app.getCurrentZone();
          var records = app.getCurrentAnyRecords();

          // record navigation
          $("#record-nav > input").unbind("click");
          app.recordTypes(true, function(type) {
            $("#link-"+type).bind("click", function() {
              location.hash = "#"+current_zone_id+"/"+type;
            });
          });

          // show: soa
          app.recordKeys("soa", function(key) {
            var value = zone.params[key] || "";
            $(".soa-"+key).text(value);
          });

          // show: a ns cname mx txt aaaa
          app.recordTypes(false, function(type) {
            $(".page-show-"+type+" .records-table tbody").empty();
            for (var id in records[type]) {
              var record = records[type][id];
              var item = $("<tr/>");
              app.recordKeys(type, function(key) {
                item.append($("<td/>").text(record.params[key]).addClass(type+"-"+key));
              });
              $(".page-show-"+type+" .records-table tbody").append(item);

              // bind
              item.bind("click", record.moveEditPage);
            }
          });

          // variable bind
          if (current_zone_id) {
            $(".zone-name-bind").text(zone.params["name"] || "(no defined zone)");
          } else {
            $(".zone-name-bind").text("(new zone)");
          }
        };

        app.refrectRecord = function() {
          var record = null;

          if (current_record_type=="soa") {
            record = app.getCurrentZone();
          } else {
            record = app.getCurrentRecord();
          }

          if (record.isNew()) {
            // new
            if (current_record_type=="soa") {
              record = new app.Zone(defaults["soa"]);
            } else {
              record = new app.Record(current_record_type, defaults[current_record_type]);
            }
            $(".record-name-bind").text("(new record)");
          } else {
            // edit
            $(".record-name-bind").text(record.params["name"] || "(no defined record)");
          }

          for (var key in record.params) {
            var el = $("#record-"+current_record_type+"-"+key);
            switch (el.attr("type")) {
            case 'text':
              el.val(record.params[key]);
              break;
            case 'checkbox':
              el.prop("checked", !!record.params[key]);
              break;
            }
          }
        };

        // view render (css / js)

        app.renderInitialize = function() {
          //$(document).tooltip();
          $(".tooltip").tooltip();

          // button
          $(".createbutton").button();
          $(".editbutton").button();

          $("#compose").bind("click", function() {
            if (current_record_type=="soa") {
              location.hash = "#"+current_record_type+"/new";
            } else {
              location.hash = "#"+current_zone_id+"/"+current_record_type+"/new";
            }
          });

          $("#edit").bind("click", function() {
            location.hash = "#"+current_zone_id+"/"+current_record_type+"/edit";
          });

          $(".savebutton").bind("click", function() {
            var record = null;

            if (current_record_type=="soa") {
              record = app.getCurrentZone();
            } else {
              record = app.getCurrentRecord();
            }

            // record params
            app.recordKeys(record.type, function(key) {
              var el = $("#record-"+record.type+"-"+key);
              switch (el.attr("type")) {
              case 'text':
                record.params[key] = el.val();
                break;
              case 'checkbox':
                record.params[key] = el.prop("checked");
                break;
              }
            });

            // request
            record.save(function(is_success, ret) {
              if (is_success) {
                app.refrectZones();
                app.refrectRecords();
                record.moveShowPage();
              } else {
                // TODO: error message
                console.log("save error: "+ret["message"]);
              }
            });
          });

          $(".destroybutton").bind("click", function() {
            var record = null;
            if (current_record_type=="soa") {
              record = app.getCurrentZone();
            } else {
              record = app.getCurrentRecord();
            }

            record.destroy(function(is_success, ret) {
              if (is_success) {
                if (record.type=="soa") {
                  app.refrectZones();
                  location.hash = "";
                } else {
                  app.refrectRecords();
                  record.moveShowPage();
                }
              } else {
                // TODO: error message
                console.log("destroy error: "+ret["message"]);
              }
            });
          });

          // location back button
          $("#back").button({
            icons: {
              primary: "ui-icon-arrowreturn-1-w"
            }
          });
          $("#back").bind("click", function() {
            history.back();
          });

          // location reload button
          $("#reload").button({
            icons: {
              primary: "ui-icon-arrowrefresh-1-e"
            }
          });
          $("#reload").bind("click", function() {
            location.reload();
          });

          // record navigation
          $("#record-nav").buttonset();

          // render loading
          app.renderLoading();
        };

        app.renderLoading = function() {
          $("#pages > *").hide();
          $("#loading").show();
        };

        app.renderZones = function() {
          $("#zonelist > li").removeClass("selected");
          $("#zonelist > li.zone"+current_zone_id).addClass("selected");
        };

        app.renderRecords = function() {
          app.renderZones();
          $("#pages > *").hide();
          $(".page-"+current_page_type+"-"+current_record_type).show();

          // compose button
          if (current_record_type=="soa") {
            $("#compose > span").html("Compose Zone");

            if (current_zone_id) {
              $(".destroybutton").button({disabled: false});
            } else {
              $(".destroybutton").button({disabled: true});
            }
          } else {
            $("#compose > span").html("New "+current_record_type.toUpperCase()+" Record");

            if (current_record_id) {
              $(".destroybutton").button({disabled: false});
            } else {
              $(".destroybutton").button({disabled: true});
            }
          }
        };

        app.renderNavView = function() {
          $("#record-nav > input").prop("checked", false);
          $("#link-"+current_record_type).prop("checked", true);
          $("#record-nav > input").prop("disabled", !current_zone_id);
          $("#record-nav").buttonset();
        };
      };

      new App().start();
    });
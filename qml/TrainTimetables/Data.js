.pragma library

var db;
function init() {
    db = openDatabaseSync("TrainTimetablesDB", "1.0", "", 1000000);
    db.transaction(function(tx) {
                       tx.executeSql("CREATE TABLE IF NOT EXISTS Favorite(ID TEXT, remark TEXT)");
                   });
}

function favorite_insert(data) {
    db.transaction(function(tx) {
                       tx.executeSql('INSERT INTO Favorite VALUES(?, ?)', data);
                   });
}

function favorite_del(id) {
    db.transaction(function(tx) {
                       tx.executeSql('DELETE FROM Favorite WHERE ID=?', [id]);
                   });
}

function favorite_clear() {
    db.transaction(function(tx) {
                       tx.executeSql('DELETE FROM Favorite');
                   });
}

function favorite_get() {
    var ret = '';
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Favorite');
                       if (rs.rows.length)
                           ret += "'"+rs.rows.item(0).ID+"'";

                       for (var i = 1; i < rs.rows.length; i++) {
                           ret += (",'" + rs.rows.item(i).ID + "'");
                       }
                   });
    return ret;
}

function favorite_destroy() {
    db.transaction(function(tx) {
                       tx.executeSql('DROP TABLE Favorite');
                   });
}

function favorite_isExist(id) {
    var ret;
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Favorite WHERE ID=?', [id]);
                       ret = rs.rows.length;
                   });
    return ret;
}

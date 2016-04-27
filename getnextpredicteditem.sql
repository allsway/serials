SELECT id2reckey(bib_record_holding_record_link.bib_record_id) AS "RECORD #(BIBLIO)",
id2reckey(item_record_id) AS "RECORD #(ITEM)",
'' AS "CALL #(ITEM)",
'' AS "VOL",
'' AS "099 |ab",
'' AS "090 |ab",
'' AS "050 |ab",
'' AS "086 |abcd",
'' AS "C",
'' AS "B",
'' AS "LOCATION",
'' AS "STATUS",
'' AS "ITYPE",
'' AS "CREATED(ITEM)",
'' AS "UPDATED (ITEM)",
'' AS "TOT CHKOUT",
'' AS "LCHKIN",
'' AS "PRICE",
'' AS "MESSAGE(ITEM)",
'' AS "NOTE(ITEM)",
'' AS "IMESSAGE",
'' AS "ITYPE",
'' AS "YTDCIRC",
'' AS "2YRCIRC",
'' AS "LABEL",
id2reckey(order_record_metadata_id) AS "RECORD #(ORDER)",
id2reckey(bib_record_holding_record_link.holding_record_id) AS "RECORD #(HOLDING)",
claimon_date_gmt - INTERVAL '1 day' * claim_days AS "Expected Date",
'0000-00-00' AS "Received Date",
marc_tag AS "MARC LINK",
tag AS "SUBFIELD",
field_content AS "PATTERN"
FROM sierra_view.bib_record_item_record_link 
LEFT JOIN sierra_view.bib_record_holding_record_link ON bib_record_holding_record_link.bib_record_id=bib_record_item_record_link.bib_record_id
LEFT JOIN sierra_view.holding_record ON bib_record_holding_record_link.holding_record_id = 
holding_record.id
LEFT JOIN sierra_view.holding_record_card ON holding_record.id=
holding_record_card.holding_record_id
LEFT JOIN sierra_view.holding_record_cardlink ON holding_record_cardlink.holding_record_card_id=holding_record_card.id
INNER JOIN 
    (SELECT record_id AS rid FROM sierra_view.subfield_view  
    WHERE
    marc_tag = '853' AND tag = '8' AND marc_ind1 = '9' GROUP BY record_id,marc_tag,tag) AS corrects
ON holding_record.id=corrects.rid
INNER JOIN 
    (SELECT max(content) AS field_content,record_id,marc_tag,tag FROM sierra_view.subfield_view  
    WHERE
    marc_tag = '853' AND tag = '8' AND marc_ind1 = '' GROUP BY record_id,marc_tag,tag) AS subfields
ON holding_record.id=subfields.record_id
WHERE  order_record_metadata_id IS NOT NULL AND
 item_record_id in 
 (SELECT id FROM sierra_view.item_view WHERE icode1=7);

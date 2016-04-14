SELECT id2reckey(item_record_id),
id2reckey(order_record_metadata_id),
id2reckey(bib_record_holding_record_link.bib_record_id),
id2reckey(bib_record_holding_record_link.holding_record_id),
claimon_date_gmt - INTERVAL '1 day' * claim_days AS "Expected Date",
'0000-00-00' as "Received Date",
marc_tag, tag, field_content
FROM sierra_view.bib_record_item_record_link 
LEFT JOIN sierra_view.bib_record_holding_record_link ON bib_record_holding_record_link.bib_record_id=bib_record_item_record_link.bib_record_id
LEFT JOIN sierra_view.holding_record ON bib_record_holding_record_link.holding_record_id = 
holding_record.id
LEFT JOIN sierra_view.holding_record_card ON holding_record.id=
holding_record_card.holding_record_id
LEFT JOIN sierra_view.holding_record_cardlink ON holding_record_cardlink.holding_record_card_id=holding_record_card.id
INNER JOIN 
    (SELECT max(content) AS field_content,record_id,marc_tag,tag FROM sierra_view.subfield_view  
    WHERE
    marc_tag = '853' AND tag = '8' AND marc_ind1 = '' GROUP BY record_id,marc_tag,tag) AS subfields
ON holding_record.id=subfields.record_id
WHERE  order_record_metadata_id is not null and
 item_record_id=reckey2id('i3657178');

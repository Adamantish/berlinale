# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


# In future I'd use HTTP fetch from something like http://country.io/names.json
# In this case I thought I'd see how easily I could scrape the wikipedia list of countries with jQuery. 
# Answer not easily enough to repeat the approach, particularly as the table was partitioned into sections by the repetition of column headings.
# 

some_countries = "Afghanistan,Albania,Algeria,American Samoa,Andorra,Angola,Anguilla,Antarctica,Antigua and Barbuda,Argentina,Armenia,Aruba,Australia,Austria,Azerbaijan,Bahamas,Bahrain,Bangladesh,Barbados,Belarus,Belgium,Belize,Benin,Bermuda,Bhutan,Bolivia,Bosnia and Herzegovina,Botswana,Brazil,Brunei Darussalam,Bulgaria,Burkina Faso,Burundi,Cambodia,Cameroon,Canada,Cape Verde,Cayman Islands,Central African Republic,Chad,Chile,China,Christmas Island,Cocos (Keeling) Islands,Colombia,Comoros,Democratic Republic of the Congo (Kinshasa),Congo, Republic of (Brazzaville),Cook Islands,Costa Rica,Ivory Coast,Croatia,Cuba,Cyprus,Czech Republic,"
some_countries << "Denmark,Djibouti,Dominica,Dominican Republic,East Timor (Timor-Leste),Ecuador,Egypt,El Salvador,Equatorial Guinea,Eritrea,Estonia,Ethiopia,Falkland Islands,Faroe Islands,Fiji,Finland,France,French Guiana,French Polynesia,French Southern Territories,Gabon,Gambia,Georgia,Germany,Ghana,Gibraltar,Great Britain,Greece,Greenland,Grenada,Guadeloupe,Guam,Guatemala,Guinea,Guinea-Bissau,Guyana,"
some_countries << "Haiti,Holy See,Honduras,Hong Kong,Hungary,Iceland,India,Indonesia,Iran (Islamic Republic of),Iraq,Ireland,Israel,Italy,Jamaica,Japan,Jordan,Kazakhstan,Kenya,Kiribati,Korea, Democratic People's Rep. (North Korea),Korea, Republic of (South Korea),Kosovo,Kuwait,Kyrgyzstan,Lao,People's Democratic Republic,Latvia,Lebanon,Lesotho,Liberia,Libya,Liechtenstein,Lithuania,Luxembourg,Macau,Macedonia,Madagascar,Malawi,Malaysia,Maldives,Mali,Malta,Marshall Islands,Martinique,Mauritania,Mauritius,Mayotte,Mexico,Micronesia,Federal States of Moldova,Republic of Monaco,Mongolia,Montenegro,Montserrat,Morocco,Mozambique,Myanmar,Burma,"
some_countries << "Namibia,Nauru,Nepal,Netherlands,Netherlands Antilles,New Caledonia,New Zealand,Nicaragua,Niger,Nigeria,Niue,Northern Mariana Islands,Norway,Oman,Pakistan,Palau,Palestinian territories,Panama,Papua New Guinea,Paraguay,Peru,Philippines,Pitcairn Island,Poland,Portugal,Puerto Rico,Qatar,Reunion Island,Romania,Russian Federation,Rwanda,Saint Kitts and Nevis,Saint Lucia,Saint Vincent and the Grenadines,Samoa,San Marino,Sao Tome and Principe,Saudi Arabia,Senegal,Serbia,Seychelles,Sierra Leone,Singapore,Slovakia (Slovak Republic),Slovenia,Solomon Islands,Somalia,South Africa,South Sudan,Spain,Sri Lanka,Sudan,Suriname,Swaziland,Sweden,Switzerland,Syria,Syrian Arab Republic,"
some_countries << "Taiwan (Republic of China),Tajikistan,Tanzania,Thailand,Tibet,Timor-Leste (East Timor),Togo,Tokelau,Tonga,Trinidad and Tobago,Tunisia,Turkey,Turkmenistan,Turks and Caicos Islands,Tuvalu,Uganda,Ukraine,United Arab Emirates,United Kingdom,United States,Uruguay,Uzbekistan,Vanuatu,Vatican City State (Holy See),Venezuela,Vietnam,Virgin Islands (British),Virgin Islands (U.S.),Wallis and Futuna Islands,Western Sahara,Yemen,Zambia,Zimbabwe,"

some_countries = some_countries.split(",")

# If I ever had to do an insert this big somewhere it affected load time for users I'd put a lot of validation rules into the DB and try to get away with a direct INSERT.

ActiveRecord::Base.transaction do
  Destination.destroy_all

  some_countries.each_with_index do | c, i|
    Destination.create!(id: i + 1, name: c)
  end
end
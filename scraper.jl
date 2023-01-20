#Read in packages
using EzXML, DataFrames, HTTP
#Get the URL for the vote
println("What year did the vote take place in? ")
vote_year = readline()
println("What was the roll call number? ")
roll_call = readline()
function make_rc_three_digit!(rc::String)
    while sizeof(rc) < 3
        rc = "0" * rc
    end
    return rc
end
roll_call = make_rc_three_digit!(roll_call)
function make_url(yr::String, rc::String)
    url_start = "https://clerk.house.gov/evs/$yr"
    url_mid = "/roll$rc"
    url_end = ".xml"
    url = url_start * url_mid * url_end
    return url
end
url = make_url(vote_year, roll_call)
#Use HTTP.get
raw = HTTP.get(url)
#Extract the XML from the HTTP request
xml_as_string = String(raw.body)
doc = parsexml(xml_as_string)
#Extract the data from the XML
rollcall_vote = doc.root
#Break out the main element into metadata and data
metadata = elements(rollcall_vote)[1]
data = elements(rollcall_vote)[2]

# Extract information in metadata to create file
legislation_num = nodecontent(findall("//legis-num", metadata)[1])
legislation_title = nodecontent(findall("//vote-desc", metadata)[1])
#Extract vector of legislators
legislators = findall("//legislator", data)
#Extract vector of votes
votes = findall("//vote", data)
# Create a function to extract a value from a vector of the keys

function pull_values(key::String, nodevec)
    baselist = String[]
    for i in 1:size(nodevec)[1]
        push!(baselist, nodevec[i][key])
    end
    return baselist
end

# Gather the identifying information for legislators
name_id = pull_values("name-id", legislators)
last_name = pull_values("sort-field", legislators)
party = pull_values("party", legislators)
state = pull_values("state", legislators)

#Create a vector of their actual votes
vote_data = nodecontent.(votes)

# Create a DataFrame of the legislators that matches the order of their votes
df = DataFrame(id=name_id, Rep=last_name, State=state, Party=party, Vote=vote_data)
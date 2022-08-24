using EzXML
using DataFrames
using CSV

#Ask for the name of the file
println("Enter the name of the file you wish to parse ")
in_file = readline()

#Read in the file
doc = readxml(in_file)
#Break out the main element
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
df = DataFrame(id = name_id, Rep = last_name, State = state, Party = party, Vote = vote_data)
CSV.write("Vote $legislation_title $legislation_num.csv", df)
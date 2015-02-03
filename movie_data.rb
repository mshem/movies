# load_data reads data from the ml-100k file and stores them
filename = ARGV.first

$movies=Hash.new
$users=Hash.new
$sim=Hash.new


def load_data(arg)
# usually u.data in the ml-100k directory

    txt= open(arg)
    while line = txt.gets do
	#turns each line into a hash review
        r=review(line)
	#this would be a good time to make a list of movies
        m = r[:movie]
        if $movies.has_key?(m)
		#simply increment the entry associated with this movie to represent popularity
            $movies[m]=$movies[m]+1
        else $movies.store(m,1)
        end
        
        #come to think of it, lets make the user list too
        # we will make a hash that associates the user id with hashes of each movie and rating
          u = r[:user]
          rating=r[:rating]
        if $users.has_key?(u)
			user=$users.fetch(u)
			#puts user
			user[m]=rating
			$users.delete(u)
			$users.store(u,user)
            
        else 
			user= {} #empty hash
			user[m]=rating
			#puts user.ratings
			#puts user.ratings
			$users.store(u,user)
        
        end

        
    end

end



def review(arg)
#makes a four entry hash out of a string 
    r = arg.split(' ')
    rev = {user: r[0].to_i, movie:r[1].to_i, rating:r[2].to_i, timestamp: r[3].to_i}
    return rev
end

#popularity takes in a movie id and returns its popularity: popularity=total rating/number of ratings

def popularity(movie_id)
    return $movies[movie_id.to_i]
end

#popularity_list will take the data and generate a list of the movies ordered by most popular to least popular. 

def popularity_list()
    
#we should have a list of movies now
        res = $movies.sort_by{|k,v| v}.reverse
        return res
end

#similarity generates a number that represents how similar two user's preferences are

def similarity(user1, user2)
	#this is represented as the number of movies in common divided by the difference in ratings for those movies.
	u1=$users[user1]
	u2=$users[user2]
	dif=0.0
	com=0
	
	
	u1.each do |movie1, rating1|
			if u2.has_key? movie1
			com = com+1
			dif=dif+(rating1-u2[movie1]).abs
			end
	end
	return com/dif
end

#most_similar returns a list of users who are most similar to the user given
def most_similar(user)
	res=Hash.new
	$users.each do |key, value|
		s=similarity(user, key)
		res.store(key, s)
		end
	
	result = res.sort_by{|k,v| v}.reverse
        return result

end

load_data(filename)
p=popularity_list()
m=most_similar(1)
puts "Ten most popular movies and their number of reviews:"
puts p.take(10)
puts "Ten least popular movies:"
puts p.drop(p.length-10)
puts "ten top users most similar to user  is:"
puts m.take(10)

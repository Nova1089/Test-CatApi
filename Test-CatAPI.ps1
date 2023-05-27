<# 
    interacting with The CAT API
    thecatapi.com
    https://developers.thecatapi.com/
    https://documenter.getpostman.com/view/5578104/RWgqUxxh#intro
#> 

$baseURL = "https://api.thecatapi.com/v1"
$searchURL = "$baseURL/images/search"
$voteURL = "$baseURL/votes"
$favouriteURL = "$baseURL/favourites"

$headers = @{
    "x-api-key" = "live_jTIsttmBmdJZswZCeeT0HDqwHsDOQnUUzacvBZhDG0e4Acm9sR3nqdushVqiJLGg";
    "Content-Type" = "application/json"
}

$searchResponse = Invoke-RestMethod -Uri $searchURL
Write-Host "Search response type is $($searchResponse.GetType()) `n"
Write-Host "Search response in JSON is $($searchResponse | ConvertTo-Json) `n"

$subID = "poopy head"
$imageID = $searchResponse.id

$voteBodyTable = @{ 
    "image_id" = "9s2";
    "sub_id" = "$subID";
    "value" = 1;
}

$voteBodyTable["image_id"] = $imageID
Write-Host "Image ID is $($voteBodyTable["image_id"]) `n"

$voteBodyJson = $voteBodyTable | ConvertTo-Json
Write-Host "JSON body is $voteBodyJson `n"

# I could add the following parameter, but it's not necessary since I've added it to the headers: -ContentType "application/json"
$upvoteResponse = Invoke-RestMethod -Uri $voteURL -Method 'Post' -Headers $headers -Body $voteBodyJson 
Write-Host "Upvote response is $upvoteResponse `n"

$allUpvoteRecords = Invoke-RestMethod -Uri $voteURL -Headers $headers
Write-Host "Upvote records list is of type $($allUpvoteRecords.GetType()) `n"
Write-Host "Upvote records list in JSON are: `n"
foreach ($record in $allUpvoteRecords)
{
    $record = $record | ConvertTo-Json
    Write-Host "$record `n"
}

$upvoteRecordID = $upvoteResponse.id
Write-Host "Upvote record ID is $upvoteRecordID `n"

$upvoteRecord = Invoke-RestMethod -Uri "$voteURL/$upvoteRecordID" -Headers $headers
Write-Host "Upvote record is $upvoteRecord `n"

$favouriteJsonBody = @"
{
    "image_id":"$imageID",
    "sub_id":"$subID"
}   
"@

$favouriteResponse = Invoke-RestMethod -Uri $favouriteURL -Method 'Post' -Headers $headers -Body $favouriteJsonBody
Write-Host "Favourite response is $favouriteResponse"

$queryParams = @{ 
    "sub_id" = $subID
}

$usersFavourites = Invoke-RestMethod -Uri $favouriteURL -Method 'Get' -Headers $headers -Body $queryParams
Write-Host "Users favourites are: `n"
foreach ($record in $usersFavourites)
{
    $record = $record | ConvertTo-Json
    Write-Host "$record `n"
}

$favouriteID = $favouriteResponse.id
$deleteFavouriteResponse = Invoke-RestMethod -Uri "$favouriteURL/$favouriteID" -Method 'Delete' -Headers $headers
Write-Host "Delete favourite response is $deleteFavouriteResponse"
Select *
From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format 

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

------------------------------------------------------------------------------------------


--Populate Property address Data

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null

Select *
From PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null

Select *
From PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

	Update a
	SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null
---------------------------------------------------------------------------------------------------------------------

	--Breaking out ADdress into Individaul Columns (Address, City, State)

	
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is null

SELECT 
  SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) AS Address,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
  From PortfolioProject.dbo.NashvilleHousing

  ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1)



ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
     FROM 
	 PortfolioProject..NashvilleHousing


	 SELECT 
	     OwnerAddress
     FROM 
	     PortfolioProject..NashvilleHousing


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
     FROM 
	     PortfolioProject..NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

SELECT *
     FROM 
	 PortfolioProject..NashvilleHousing

	 ---------------------------------------------------------------------------------------------------------------------


	 --Change Y and N to Yes in "Sold as Vacant" Field 

	 SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
     FROM 
	 PortfolioProject..NashvilleHousing
	 GROUP BY 
	 SoldAsVacant
	 ORDER BY
	 2

	 SELECT SoldAsVacant
	, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	       When SoldAsVacant = 'N' THEN 'No'
		   ELSE SoldAsVacant
		   END
	  FROM 
	 PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	       When SoldAsVacant = 'N' THEN 'No'
		   ELSE SoldAsVacant
		   END

-------------------------------------------------------------------------------------------------------------------------------------------------

--Removing Duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM 
	 PortfolioProject..NashvilleHousing
--ORDER BY
	--ParcelID
)
Select*
From RowNumCTE
WHERE row_num > 1
Order by PropertyAddress

-------------------------------------------------------------------------------------------------------------------------
--Delete unused columns 

	 SELECT * 
	 FROM 
	 PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate
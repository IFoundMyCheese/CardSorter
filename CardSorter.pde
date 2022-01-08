import g4p_controls.*;

Card card;
ArrayList<Card> originalStack = new ArrayList<Card>();
ArrayList<Card> animatedStack = new ArrayList<Card>();
ArrayList<Integer> indicesToBeSwapped = new ArrayList<Integer>();
ArrayList<Card> cardsToBeSwapped = new ArrayList<Card>();
ArrayList<Card> cardBeingSwapped = new ArrayList<Card>();
String[] cards = {"2C", "2D", "2H", "2S", "3C", "3D", "3H", "3S", "4C", "4D", "4H", "4S", "5C", "5D", "5H", "5S", "6C", "6D", "6H", "6S", "7C", "7D", "7H", "7S", 
  "8C", "8D", "8H", "8S", "9C", "9D", "9H", "9S", "10C", "10D", "10H", "10S", "JC", "JD", "JH", "JS", "QC", "QD", "QH", "QS", "KC", "KD", "KH", "KS", "AC", "AD", 
  "AH", "AS"};
String sortingAlgorithm;
String animation;
Card[] cardDeck = new Card[53];
int cardsToBeSorted;
int randomCard;
int index = 0;
int numOfCardsSwapped = 0;
int swapNum = 0;
int frame = 0;
int padding = 50;
int speed;
float x = padding;
float scale = 2.0;
float scaleFactor;
boolean isInArray;
boolean swap = false;
boolean moveToNextSwap = false;
boolean startSwapping = false;
boolean moveToNextCard = false;
int tempIndex;


void setup () {
  createGUI();
  size(800, 800);
  cardsToBeSorted = cardEvents.getValueI();
  sortingAlgorithm = listEvents.getSelectedText();
  animation = animationType.getSelectedText();
  speed = speedEvents.getValueI();
  getScaleFactor();
  generateCards();
  setupCards();
}

void setupCards() {

  getRandomCards();
  fillInAnimatedStack();

  if (sortingAlgorithm.equals("bubble sort")) {
    bubbleSort();
  } else if (sortingAlgorithm.equals("insertion sort")) {
    insertionSort();
  } else if (sortingAlgorithm.equals("selection sort")) {
    selectionSort();
  } else if (sortingAlgorithm.equals("merge sort")) {
    mergeSort(originalStack, 0, originalStack.size() - 1);
  } else if (sortingAlgorithm.equals("quick sort")) {
    quickSort(originalStack, 0, originalStack.size() - 1);
  }

  numOfCardsSwapped = indicesToBeSwapped.size();
  index = animatedStack.size() - 1;
}

void getScaleFactor() {
  scaleFactor = ((width)/16) / 691.0*scale;
}

void generateCards() {

  for (int i = 0; i < cards.length; i++) {
    card = new Card(i, cards[i], scaleFactor);
    cardDeck[i] = card;
  }
}

void getRandomCards() {

  while (index < cardsToBeSorted) {
    randomCard = int(random(0, 52));
    isInArray = checkIfAlreadyInArray(originalStack, randomCard);
    if (!isInArray) {
      originalStack.add(cardDeck[randomCard]);
      index++;
    }
  }
}

void fillInAnimatedStack() {
  for (int i = 0; i < originalStack.size(); i++) {
    animatedStack.add(originalStack.get(i));
    animatedStack.get(i).saveCoordinates(x);
    x += (width - padding*2)/(cardsToBeSorted*scale);
  }
}

boolean checkIfAlreadyInArray(ArrayList<Card> A, int w) {

  for (int i = 0; i < A.size(); i++) {
    if (w == A.get(i).num) {
      return true;
    }
  }
  return false;
}

void draw() {
  if (startSwapping == false && index >= 0 ) {
    background(205);
  }

  if (startSwapping == false) {
    if (index >= 0) {
      for (int i = 0; i < animatedStack.size(); i++) {
        animatedStack.get(i).keepDrawing();
      }
      if (moveToNextCard == false) {
        animatedStack.get(index).drawCards();
      } else {
        index--;
        moveToNextCard = false;
      }
    } else {
      startSwapping = true;
      delay(1000);
    }
  } 


  if (startSwapping == true) {
    if (swapNum <= numOfCardsSwapped && swap == true) {
      background(205);
    }

    for (int i = 0; i < animatedStack.size(); i++) {
      if (cardsToBeSwapped.size() == 2) {
        if (animation.equals("linear")) {
          animatedStack.get(i).linear(cardsToBeSwapped.get(1), cardsToBeSwapped.get(0));
        } else {
          animatedStack.get(i).circular(cardsToBeSwapped.get(1), cardsToBeSwapped.get(0));
        }
      }
    }

    if (swap == false ) {
      cardsToBeSwapped.clear();
    }

    if (swap == false && swapNum < numOfCardsSwapped  && frame % speed == 0) {//factors of 3
      if (sortingAlgorithm.equals("bubble sort") || sortingAlgorithm.equals("insertion sort")) {
        Card temp = animatedStack.get(indicesToBeSwapped.get(swapNum));
        tempIndex = animatedStack.indexOf(cardBeingSwapped.get(swapNum));
        animatedStack.set(indicesToBeSwapped.get(swapNum), cardBeingSwapped.get(swapNum));
        animatedStack.set(tempIndex, temp);
        if (sortingAlgorithm.equals("bubble sort")) {
          cardsToBeSwapped.add(temp);
          cardsToBeSwapped.add(animatedStack.get(indicesToBeSwapped.get(swapNum)));
        } else {
          cardsToBeSwapped.add(animatedStack.get(indicesToBeSwapped.get(swapNum)));
          cardsToBeSwapped.add(temp);
        }
      } else {
        while (moveToNextSwap == false && swapNum < numOfCardsSwapped) {
          Card temp = animatedStack.get(indicesToBeSwapped.get(swapNum));
          tempIndex = animatedStack.indexOf(cardBeingSwapped.get(swapNum));
          if (tempIndex == indicesToBeSwapped.get(swapNum)) {
            swapNum++;
          } else {
            animatedStack.set(indicesToBeSwapped.get(swapNum), cardBeingSwapped.get(swapNum));
            animatedStack.set(tempIndex, temp);
            if (sortingAlgorithm.equals("selection sort")) {
              cardsToBeSwapped.add(temp);
              cardsToBeSwapped.add(animatedStack.get(indicesToBeSwapped.get(swapNum)));
            } else {
              cardsToBeSwapped.add(animatedStack.get(indicesToBeSwapped.get(swapNum)));
              cardsToBeSwapped.add(temp);
            }

            moveToNextSwap = true;
          }
        }
        moveToNextSwap = false;
      }
      swapNum++;
      swap = true;
    }
  }
  frame++;
}

void bubbleSort() {
  for (int p = 1; p < originalStack.size(); p++) {
    for (int i = 0; i < originalStack.size()-p; i++) {
      if (originalStack.get(i).num > originalStack.get(i+1).num) {
        indicesToBeSwapped.add(i);
        cardBeingSwapped.add(originalStack.get(i+1));
        Card temp = originalStack.get(i);
        originalStack.set(i, originalStack.get(i+1));
        originalStack.set(i+1, temp);
      }
    }
  }
}

void insertionSort() {
  for (int h = 1; h < originalStack.size(); h++) {
    int c = h;
    while (c > 0 && originalStack.get(c-1).num > originalStack.get(c).num) {
      indicesToBeSwapped.add(c);
      cardBeingSwapped.add(originalStack.get(c-1));
      Card temp = originalStack.get(c);
      originalStack.set(c, originalStack.get(c-1));
      originalStack.set(c-1, temp);
      c--;
    }
  }
}

void selectionSort() 
{ 
  ArrayList<Card> arr = originalStack;
  int n = arr.size(); 

  // One by one move boundary of unsorted subarray 
  for (int i = 0; i < n-1; i++) { 
    // Find the minimum element in unsorted array 
    int min_idx = i; 
    for (int j = i+1; j < n; j++) { 
      if (arr.get(j).num < arr.get(min_idx).num) { 
        min_idx = j;
      }
    }
    indicesToBeSwapped.add(min_idx);
    cardBeingSwapped.add(arr.get(i));
    Card temp = arr.get(min_idx);
    originalStack.set(min_idx, arr.get(i));
    originalStack.set(i, temp);
  }
} 

void mergeSort(ArrayList<Card> arr, int l, int r) {
  if (l < r) {
    // Find the middle point
    int m = (l + r) / 2;


    // Sort first and second halves
    mergeSort(arr, l, m);
    mergeSort(arr, m + 1, r);

    // Merge the sorted halves
    merge(arr, l, m, r);
  }
}

void merge(ArrayList<Card> arr, int l, int m, int r) {
  int n1 = m - l + 1;
  int n2 = r - m;

  /* Create temp arrays */
  Card a[] = new Card[n1];
  Card b[] = new Card[n2];

  /*Copy data to temp arrays*/
  for (int i = 0; i < n1; i++) {
    a[i] = arr.get(l+i);
  }
  for (int j = 0; j < n2; j++) {
    b[j] = arr.get(m+1+j);
  }

  /* Merge the temp arrays */

  // Initial indexes of first and second subarrays
  int i = 0, j = 0;

  // Initial index of merged subarry array
  int k = l;
  while (i < n1 && j < n2) {
    if (a[i].num <= b[j].num) {
      arr.set(k, a[i]);
      cardBeingSwapped.add(a[i]);
      indicesToBeSwapped.add(k);

      //d.add(i);
      i++;
    } else {
      arr.set(k, b[j]);
      cardBeingSwapped.add(b[j]);
      indicesToBeSwapped.add(k);
      //d.add(j);
      j++;
    }
    k++;
  }

  /* Copy remaining elements of a[] if any */  // free ride
  while (i < n1) {
    arr.set(k, a[i]);
    cardBeingSwapped.add(a[i]);
    indicesToBeSwapped.add(k);
    //indicesToBeSwapped.add(i);
    i++;
    k++;
  }

  /* Copy remaining elements of r[] if any */  // free ride
  while (j < n2) {
    arr.set(k, b[j]);
    cardBeingSwapped.add(b[j]);
    indicesToBeSwapped.add(k);
    j++;
    k++;
  }
}


/* The main function that implements QuickSort() 
 arr[] --> Array to be sorted, 
 low  --> Starting index, 
 high  --> Ending index */
void quickSort(ArrayList<Card> arr, int low, int high) 
{ 
  if (low < high) 
  { 
    /* pi is partitioning index, arr[pi] is  
     now at right place */
    int pi = partition(arr, low, high); 

    // Recursively sort elements before 
    // partition and after partition 
    quickSort(arr, low, pi-1); 
    quickSort(arr, pi+1, high);
  }
} 

int partition(ArrayList<Card> arr, int low, int high) 
{ 
  int pivot = arr.get(high).num;  
  int i = (low-1); // index of smaller element 
  for (int j=low; j<high; j++) 
  { 
    // If current element is smaller than the pivot 
    if (arr.get(j).num < pivot) 
    { 
      i++; 
      indicesToBeSwapped.add(i);
      cardBeingSwapped.add(arr.get(j));
      Card temp = arr.get(i); 
      arr.set(i, arr.get(j));
      arr.set(j, temp);
    }
  } 

  // swap arr[i+1] and arr[high] (or pivot) 
  indicesToBeSwapped.add(i+1);
  cardBeingSwapped.add(arr.get(high));
  Card temp = arr.get(i+1);
  arr.set(i+1, arr.get(high));
  arr.set(high, temp);

  return i+1;
} 

void clearCards() {
  originalStack = new ArrayList<Card>();
  animatedStack = new ArrayList<Card>();
  indicesToBeSwapped = new ArrayList<Integer>();
  cardsToBeSwapped = new ArrayList<Card>();
  cardBeingSwapped = new ArrayList<Card>();
  index = 0;
  numOfCardsSwapped = 0;
  swapNum = 0;
  frame = 0;
  x = padding;
  swap = false;
  moveToNextSwap = false;
  startSwapping = false;
  moveToNextCard = false;
  setupCards();
}

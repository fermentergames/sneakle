export interface QueuedPuzzle {
  levelName: string;
  levelTag: string;        // "daily", "community", "special", etc
  gameData: string;
  levelCreator: string;
  levelDate: string;       // ISO string
  nonStandard: string;       // "0" or "1"
}
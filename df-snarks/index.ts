/**
 * This package will accept arguments with the same interface as darkforest
 */

export interface RevealSnarkInput {
  x: string;
  y: string;
  PLANETHASH_KEY: string;
  SPACETYPE_KEY: string;
  SCALE: string;
  xMirror: string;
  yMirror: string;
}

export type RevealSnarkContractCallArgs = [
  [string, string, string, string, string, string, string, string, string],
  string
]

export interface InitSnarkInput {
  x: string;
  y: string;
  r: string;
  PLANETHASH_KEY: string;
  SPACETYPE_KEY: string;
  SCALE: string;
  xMirror: string;
  yMirror: string;
}

export type InitSnarkContractCallArgs = [
  [string, string, string, string, string, string],
  string
]

export interface MoveSnarkInput {
  x1: string;
  y1: string;
  x2: string;
  y2: string;
  r: string;
  distMax: string;
  PLANETHASH_KEY: string;
  SPACETYPE_KEY: string;
  SCALE: string;
  xMirror: string;
  yMirror: string;
}

export type MoveSnarkContractCallArgs = [
  [string, string, string, string, string, string, string, string, string, string, string, string],
  string
]

export interface BiomebaseSnarkInput {
  x: string;
  y: string;
  PLANETHASH_KEY: string;
  BIOMEBASE_KEY: string;
  SCALE: string;
  xMirror: string;
  yMirror: string;
}

export type BiomebaseSnarkContractCallArgs = [
  [string, string, string, string, string],
  string
]

export interface WhitelistSnarkInput {
  key: string;
  recipient: string;
}

export type WhitelistSnarkContractCallArgs = [
  [string, string],
  string
]

export type ContractCallArgs =
  | RevealSnarkContractCallArgs
  | InitSnarkContractCallArgs
  | MoveSnarkContractCallArgs
  | BiomebaseSnarkContractCallArgs
  | WhitelistSnarkContractCallArgs;


export function buildContractCallArgs(
  snarkProof: string,
  publicSignals: string[]
): ContractCallArgs {
  return [
    publicSignals,
    snarkProof
  ]
}
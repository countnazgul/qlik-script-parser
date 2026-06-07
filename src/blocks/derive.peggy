// DERIVE block

deriveBlock						= 'DERIVE'i sep 'FIELDS'i spaces endOfRow { return false; }

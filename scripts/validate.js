const fs = require('fs');

try {
  const signatures = JSON.parse(fs.readFileSync('signatures/community-signatures.json', 'utf8'));
  
  const requiredFields = ['name', 'regex', 'score', 'severity', 'description', 'category'];
  const validSeverities = ['info', 'medium', 'high', 'critical'];
  
  signatures.forEach((sig, index) => {
    requiredFields.forEach(field => {
      if (!sig[field]) {
        throw new Error(`Signature ${index}: Missing required field '${field}'`);
      }
    });
    
    if (!validSeverities.includes(sig.severity)) {
      throw new Error(`Signature ${index}: Invalid severity '${sig.severity}'`);
    }
    
    if (sig.score < 0 || sig.score > 100) {
      throw new Error(`Signature ${index}: Score must be between 0-100`);
    }
    
    // Test regex validity
    try {
      new RegExp(sig.regex, sig.flags || 'i');
    } catch (e) {
      throw new Error(`Signature ${index}: Invalid regex - ${e.message}`);
    }
  });
  
  console.log(`✅ All ${signatures.length} signatures are valid!`);
} catch (error) {
  console.error('❌ Validation failed:', error.message);
  process.exit(1);
}